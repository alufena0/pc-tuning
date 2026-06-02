<#
.SYNOPSIS
Reports the graphics-driver-advertised theoretical GPU memory capacity per adapter.

.DESCRIPTION
Queries DXGI adapter descriptors directly via dxgi.dll.

Reports:
  - DedicatedVideoMemory: local/physical VRAM exposed by the graphics driver.
  - DedicatedSystemMemory: dedicated non-local system memory, usually 0 on modern systems.
  - SharedSystemMemory: system RAM the OS/driver exposes as shared GPU memory.
  - TheoreticalAppVisibleMemory: DedicatedVideoMemory + SharedSystemMemory.

This intentionally does NOT calculate currently-free VRAM and does NOT subtract memory
used by other running applications.

.PARAMETER IncludeSoftwareAdapters
Include software adapters such as Microsoft Basic Render Driver.

.PARAMETER RawBytes
Return byte values instead of GiB.

.EXAMPLE
.\Get-TheoreticalGpuMemory.ps1

.EXAMPLE
.\Get-TheoreticalGpuMemory.ps1 -RawBytes

.NOTES
Requires Windows with DXGI available.
Works in Windows PowerShell 5.1 and PowerShell 7+.
#>

[CmdletBinding()]
param(
    [switch]$IncludeSoftwareAdapters,
    [switch]$RawBytes
)

$ErrorActionPreference = 'Stop'

$dxgiSource = @"
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;

namespace DxgiGpuMemory
{
    [Flags]
    public enum DXGI_ADAPTER_FLAG : uint
    {
        NONE = 0,
        REMOTE = 1,
        SOFTWARE = 2,
        FORCE_DWORD = 0xffffffff
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct DXGI_ADAPTER_DESC1
    {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 128)]
        public string Description;

        public uint VendorId;
        public uint DeviceId;
        public uint SubSysId;
        public uint Revision;

        public UIntPtr DedicatedVideoMemory;
        public UIntPtr DedicatedSystemMemory;
        public UIntPtr SharedSystemMemory;

        public long AdapterLuid;
        public DXGI_ADAPTER_FLAG Flags;
    }

    [ComImport]
    [Guid("2411e7e1-12ac-4ccf-bd14-9798e8534dc0")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IDXGIAdapter
    {
        // IDXGIObject
        [PreserveSig] int SetPrivateData(ref Guid Name, uint DataSize, IntPtr pData);
        [PreserveSig] int SetPrivateDataInterface(ref Guid Name, IntPtr pUnknown);
        [PreserveSig] int GetPrivateData(ref Guid Name, ref uint pDataSize, IntPtr pData);
        [PreserveSig] int GetParent(ref Guid riid, out IntPtr ppParent);

        // IDXGIAdapter
        [PreserveSig] int EnumOutputs(uint Output, out IntPtr ppOutput);
        [PreserveSig] int GetDesc(out IntPtr pDesc);
        [PreserveSig] int CheckInterfaceSupport(ref Guid InterfaceName, out long pUMDVersion);
    }

    [ComImport]
    [Guid("29038f61-3839-4626-91fd-086879011a05")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IDXGIAdapter1
    {
        // IDXGIObject
        [PreserveSig] int SetPrivateData(ref Guid Name, uint DataSize, IntPtr pData);
        [PreserveSig] int SetPrivateDataInterface(ref Guid Name, IntPtr pUnknown);
        [PreserveSig] int GetPrivateData(ref Guid Name, ref uint pDataSize, IntPtr pData);
        [PreserveSig] int GetParent(ref Guid riid, out IntPtr ppParent);

        // IDXGIAdapter
        [PreserveSig] int EnumOutputs(uint Output, out IntPtr ppOutput);
        [PreserveSig] int GetDesc(out IntPtr pDesc);
        [PreserveSig] int CheckInterfaceSupport(ref Guid InterfaceName, out long pUMDVersion);

        // IDXGIAdapter1
        [PreserveSig] int GetDesc1(out DXGI_ADAPTER_DESC1 pDesc);
    }

    [ComImport]
    [Guid("770aae78-f26f-4dba-a829-253c83d1b387")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface IDXGIFactory1
    {
        // IDXGIObject
        [PreserveSig] int SetPrivateData(ref Guid Name, uint DataSize, IntPtr pData);
        [PreserveSig] int SetPrivateDataInterface(ref Guid Name, IntPtr pUnknown);
        [PreserveSig] int GetPrivateData(ref Guid Name, ref uint pDataSize, IntPtr pData);
        [PreserveSig] int GetParent(ref Guid riid, out IntPtr ppParent);

        // IDXGIFactory
        [PreserveSig] int EnumAdapters(uint Adapter, out IntPtr ppAdapter);
        [PreserveSig] int MakeWindowAssociation(IntPtr WindowHandle, uint Flags);
        [PreserveSig] int GetWindowAssociation(out IntPtr pWindowHandle);
        [PreserveSig] int CreateSwapChain(IntPtr pDevice, IntPtr pDesc, out IntPtr ppSwapChain);
        [PreserveSig] int CreateSoftwareAdapter(IntPtr Module, out IntPtr ppAdapter);

        // IDXGIFactory1
        [PreserveSig] int EnumAdapters1(uint Adapter, out IDXGIAdapter1 ppAdapter);
        [PreserveSig] int IsCurrent();
    }

    public sealed class GpuMemoryInfo
    {
        public int AdapterIndex { get; set; }
        public string Description { get; set; }
        public string VendorId { get; set; }
        public string DeviceId { get; set; }
        public bool IsSoftwareAdapter { get; set; }
        public ulong DedicatedVideoMemoryBytes { get; set; }
        public ulong DedicatedSystemMemoryBytes { get; set; }
        public ulong SharedSystemMemoryBytes { get; set; }
        public ulong TheoreticalAppVisibleMemoryBytes { get; set; }
    }

    public static class NativeMethods
    {
        public static readonly Guid IDXGIFactory1Guid = new Guid("770aae78-f26f-4dba-a829-253c83d1b387");

        [DllImport("dxgi.dll", ExactSpelling = true)]
        public static extern int CreateDXGIFactory1(
            ref Guid riid,
            out IDXGIFactory1 ppFactory
        );
    }

    public static class Query
    {
        private const uint DXGI_ERROR_NOT_FOUND = 0x887A0002;

        private static void ThrowIfFailed(int hr, string message)
        {
            if (hr < 0)
            {
                throw new COMException(message + " HRESULT: 0x" + ((uint)hr).ToString("X8"), hr);
            }
        }

        public static GpuMemoryInfo[] GetAdapters(bool includeSoftwareAdapters)
        {
            IDXGIFactory1 factory = null;
            Guid iid = NativeMethods.IDXGIFactory1Guid;

            int hr = NativeMethods.CreateDXGIFactory1(ref iid, out factory);
            ThrowIfFailed(hr, "CreateDXGIFactory1 failed.");

            var list = new List<GpuMemoryInfo>();

            try
            {
                for (uint index = 0; ; index++)
                {
                    IDXGIAdapter1 adapter = null;
                    hr = factory.EnumAdapters1(index, out adapter);

                    if ((uint)hr == DXGI_ERROR_NOT_FOUND)
                    {
                        break;
                    }

                    ThrowIfFailed(hr, "EnumAdapters1 failed at adapter index " + index + ".");

                    try
                    {
                        DXGI_ADAPTER_DESC1 desc;
                        hr = adapter.GetDesc1(out desc);
                        ThrowIfFailed(hr, "GetDesc1 failed at adapter index " + index + ".");

                        bool isSoftware = (desc.Flags & DXGI_ADAPTER_FLAG.SOFTWARE) == DXGI_ADAPTER_FLAG.SOFTWARE;

                        if (!isSoftware || includeSoftwareAdapters)
                        {
                            ulong dedicatedVideo = desc.DedicatedVideoMemory.ToUInt64();
                            ulong dedicatedSystem = desc.DedicatedSystemMemory.ToUInt64();
                            ulong sharedSystem = desc.SharedSystemMemory.ToUInt64();

                            list.Add(new GpuMemoryInfo
                            {
                                AdapterIndex = (int)index,
                                Description = (desc.Description ?? String.Empty).Trim(),
                                VendorId = "0x" + desc.VendorId.ToString("X4"),
                                DeviceId = "0x" + desc.DeviceId.ToString("X4"),
                                IsSoftwareAdapter = isSoftware,
                                DedicatedVideoMemoryBytes = dedicatedVideo,
                                DedicatedSystemMemoryBytes = dedicatedSystem,
                                SharedSystemMemoryBytes = sharedSystem,
                                TheoreticalAppVisibleMemoryBytes = dedicatedVideo + sharedSystem
                            });
                        }
                    }
                    finally
                    {
                        if (adapter != null)
                        {
                            Marshal.ReleaseComObject(adapter);
                        }
                    }
                }
            }
            finally
            {
                if (factory != null)
                {
                    Marshal.ReleaseComObject(factory);
                }
            }

            return list.ToArray();
        }
    }
}
"@

if (-not ("DxgiGpuMemory.Query" -as [type])) {
    Add-Type -TypeDefinition $dxgiSource -Language CSharp
}

function Convert-BytesForOutput {
    param([UInt64]$Bytes)

    if ($RawBytes) {
        return $Bytes
    }

    return [Math]::Round(($Bytes / 1GB), 2)
}

$unit = if ($RawBytes) { "Bytes" } else { "GiB" }

[DxgiGpuMemory.Query]::GetAdapters([bool]$IncludeSoftwareAdapters) |
    ForEach-Object {
        [pscustomobject]@{
            AdapterIndex                = $_.AdapterIndex
            Description                 = $_.Description
            VendorId                    = $_.VendorId
            DeviceId                    = $_.DeviceId
            IsSoftwareAdapter           = $_.IsSoftwareAdapter
            DedicatedVideoMemory        = Convert-BytesForOutput $_.DedicatedVideoMemoryBytes
            DedicatedSystemMemory       = Convert-BytesForOutput $_.DedicatedSystemMemoryBytes
            SharedSystemMemory          = Convert-BytesForOutput $_.SharedSystemMemoryBytes
            TheoreticalAppVisibleMemory = Convert-BytesForOutput $_.TheoreticalAppVisibleMemoryBytes
            Unit                        = $unit
            Meaning                     = "Driver-advertised capacity; does not subtract VRAM used by other applications"
        }
    } |
    Format-Table -AutoSize
PAUSE