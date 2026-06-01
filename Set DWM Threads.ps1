Start-Sleep -Seconds 1

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class DwmTuner {
    [DllImport("kernel32.dll")] public static extern IntPtr OpenThread(int access, bool inherit, uint tid);
    [DllImport("kernel32.dll")] public static extern IntPtr OpenProcess(int access, bool inherit, int pid);
    [DllImport("kernel32.dll")] public static extern bool SetThreadPriority(IntPtr hThread, int prio);
    [DllImport("kernel32.dll")] public static extern uint SuspendThread(IntPtr hThread);
    [DllImport("kernel32.dll")] public static extern bool CloseHandle(IntPtr h);
    [DllImport("ntdll.dll")]    public static extern int NtQueryInformationThread(IntPtr hThread, int cls, IntPtr buf, int size, out int ret);
    [DllImport("psapi.dll", CharSet=CharSet.Unicode)] public static extern uint GetMappedFileNameW(IntPtr hProc, IntPtr addr, StringBuilder name, uint size);
}
"@

function Get-ThreadMod([IntPtr]$hProc, [IntPtr]$hThread) {
    $pAddr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal([IntPtr]::Size)
    try {
        $dummy = 0
        [DwmTuner]::NtQueryInformationThread($hThread, 9, $pAddr, [IntPtr]::Size, [ref]$dummy) | Out-Null
        $addr = [System.Runtime.InteropServices.Marshal]::ReadIntPtr($pAddr)
        $sb = New-Object System.Text.StringBuilder 512
        [DwmTuner]::GetMappedFileNameW($hProc, $addr, $sb, 512) | Out-Null
        return $sb.ToString()
    } finally {
        [System.Runtime.InteropServices.Marshal]::FreeHGlobal($pAddr)
    }
}

$dwm   = Get-Process dwm | Select-Object -First 1
$hProc = [DwmTuner]::OpenProcess(0x0410, $false, $dwm.Id)

$boosted = 0
$suspended = 0
$idled = 0
$skipped = 0

$suspendTargets = @("ISM.dll", "GameInput.dll", "Windows.Gaming.Input.dll")

$idleTargets = @(
    "ntdll.dll",
    "uDWM.dll",
    "DispBroker.dll",
    "nvwgf2umx.dll",
    "shcore.dll",
    "combase.dll",
    "crypt32.dll"
)

foreach ($t in $dwm.Threads) {
    $hThread = [DwmTuner]::OpenThread(0x1FFFFF, $false, [uint32]$t.Id)
    if ($hThread -eq [IntPtr]::Zero) { $skipped++; continue }

    $mod     = Get-ThreadMod $hProc $hThread
    $modName = ($mod -split '\\' | Select-Object -Last 1)

    if ($modName -eq "dwm.exe") {
        $skipped++
        [DwmTuner]::CloseHandle($hThread) | Out-Null
        continue
    }

    if ($modName -eq "dwmcore.dll" -or $modName -eq "dwmredir.dll") {
        [DwmTuner]::SetThreadPriority($hThread, 15) | Out-Null
        $boosted++
    }
    elseif ($suspendTargets | Where-Object { $modName -like "*$_*" }) {
        [DwmTuner]::SetThreadPriority($hThread, -15) | Out-Null
        [DwmTuner]::SuspendThread($hThread) | Out-Null
        $suspended++
    }
    elseif ($idleTargets | Where-Object { $modName -like "*$_*" }) {
        [DwmTuner]::SetThreadPriority($hThread, -15) | Out-Null
        $idled++
    }
    else {
        $skipped++
    }

    [DwmTuner]::CloseHandle($hThread) | Out-Null
}

[DwmTuner]::CloseHandle($hProc) | Out-Null

Write-Host ""
Write-Host "========== TUNING COMPLETE ==========" -ForegroundColor Cyan
Write-Host "Boosted  (Input/Latency) : $boosted"   -ForegroundColor Green
Write-Host "Suspended (Frozen)       : $suspended"  -ForegroundColor Yellow
Write-Host "Idled    (NVIDIA/System) : $idled"      -ForegroundColor White
Write-Host "Skipped  (Protected)     : $skipped"
Write-Host "======================================"
Stop-Process -Name "TrustedInstaller" -Force
exit