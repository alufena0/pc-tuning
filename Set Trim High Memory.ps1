$threshold = 7GB
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MemTrim {
    [DllImport("kernel32.dll")]
    public static extern bool SetProcessWorkingSetSize(IntPtr hProcess, IntPtr dwMinimumWorkingSetSize, IntPtr dwMaximumWorkingSetSize);
}
"@
Get-Process | Where-Object { $_.WorkingSet64 -gt $threshold -and $_.Responding -and $_.Id -ne 0 } | ForEach-Object {
    [MemTrim]::SetProcessWorkingSetSize($_.Handle, [IntPtr]-1, [IntPtr]-1) | Out-Null
}
exit