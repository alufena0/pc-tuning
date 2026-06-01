#Requires -RunAsAdministrator

$ngen64 = "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\ngen.exe"
$ngen32 = "$env:SystemRoot\Microsoft.NET\Framework\v4.0.30319\ngen.exe"

$searchPaths = @(
    "$env:SystemRoot\assembly",
    "$env:SystemRoot\Microsoft.NET\assembly",
    "$env:SystemRoot\System32",
    "$env:SystemRoot\SysWOW64",
    "$env:ProgramFiles",
    "${env:ProgramFiles(x86)}"
)

function Invoke-Ngen($ngenExe, $label) {
    if (-not (Test-Path $ngenExe)) { return }

    Write-Host "[$label] Processing queue..."
    & $ngenExe executeQueuedItems /nologo *> $null

    Write-Host "[$label] Compiling assemblies..."
    foreach ($path in $searchPaths) {
        if (-not (Test-Path $path)) { continue }
        Get-ChildItem -Path $path -Recurse -File -Include "*.dll","*.exe" -ErrorAction SilentlyContinue |
        Where-Object { $_.Length -gt 0 } |
        ForEach-Object {
            $file = $_
            try { $null = [Reflection.AssemblyName]::GetAssemblyName($file.FullName) }
            catch { continue }
            & $ngenExe install $file.FullName /nologo *> $null
        }
    }

    Write-Host "[$label] Updating existing images..."
    & $ngenExe update /force /nologo *> $null

    Write-Host "[$label] Done."
}

Invoke-Ngen $ngen64 "x64"
Invoke-Ngen $ngen32 "x86"