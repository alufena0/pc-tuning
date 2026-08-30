param([string]$TargetPath)
$excludedFolders = 'node_modules|\.next|\.git|platforms|www' # Folders to exclude from both structure and contents
$excludedFiles = 'package-lock\.json' # Individual files to exclude
$textExt = @('.txt','.log','.md','.json','.js','.ts','.jsx','.tsx','.html','.htm','.css','.scss','.xml','.yaml','.yml','.ps1','.bat','.sh','.env','.config','.ini','.toml','.cs','.py','.rb','.php','.java','.c','.cpp','.h','.sql','.prisma','.graphql','.lock','.gitignore','.reg','.vbs','.lua','.rs','.go','.swift','.kt','.dart','.r','.m','.f','.asm','.s','.pl','.pm','.tcl','.awk','.sed','.vim','.conf','.cfg','.properties','.gradle','.cmake','.make','.mk','.dockerfile','.tf','.hcl','.proto','.thrift','.avsc','.mdx','.vue','.svelte','.astro','.sass','.less','.styl','.pug','.ejs','.handlebars','.mustache','.liquid','.nip','.csv','.cmake','.cmd') # Only these extensions will have their contents read
$targetClean = $TargetPath.TrimEnd('\')
$output = Join-Path "$env:USERPROFILE\Desktop" "$((Split-Path $targetClean -Leaf))_dump.txt"
$writer = [System.IO.StreamWriter]::new($output, $false, [System.Text.UTF8Encoding]::new($false))

Write-Host "Listing files..."
$files = @(Get-ChildItem -Path $TargetPath -Recurse -File -Force -ErrorAction SilentlyContinue |
  Where-Object { $_.FullName -notmatch "\\($excludedFolders)\\" } |
  Where-Object { $_.Name -notmatch "^($excludedFiles)$" })

Write-Host "Listing folders (single pass)..."
$excludedDirs = [System.Collections.Generic.List[string]]::new()
$emptyDirs = [System.Collections.Generic.List[string]]::new()

# PS 5.1 fix: HashSet[string]::new(array) throws ambiguous overload; build with .Add() instead.
$foldersWithFiles = [System.Collections.Generic.HashSet[string]]::new()
foreach ($f in $files) { [void]$foldersWithFiles.Add($f.DirectoryName) }

Get-ChildItem -Path $TargetPath -Recurse -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object {
  if ($_.Name -match "^($excludedFolders)$" -and $_.Parent.FullName -notmatch "\\($excludedFolders)($|\\)") {
    $excludedDirs.Add($_.FullName)
    return
  }
  if ($_.FullName -match "\\($excludedFolders)\\") { return } # inside an excluded tree, skip entirely
  if (-not $foldersWithFiles.Contains($_.FullName)) {
    $emptyDirs.Add($_.FullName)
  }
}

Write-Host "Found $($files.Count) files, $($emptyDirs.Count) empty folders. Building structure..."
$structureEntries = @()
$structureEntries += $files | ForEach-Object { $_.FullName }
$structureEntries += $emptyDirs | ForEach-Object { "$_\ [empty]" }
$structureEntries += $excludedDirs | ForEach-Object { "$_\ [excluded]" }
$structureEntries = $structureEntries | Sort-Object

$writer.WriteLine("========== STRUCTURE ==========")
$structureEntries | ForEach-Object { $writer.WriteLine($_) }
$writer.WriteLine("========== CONTENTS ==========")

$i = 0
$files | ForEach-Object {
  $i++
  Write-Host "`rReading file $i of $($files.Count)...          " -NoNewline
  if ($textExt -notcontains $_.Extension.ToLower()) { return }
  $writer.WriteLine("`n====== $($_.FullName) ======")
  try { $writer.WriteLine([System.IO.File]::ReadAllText($_.FullName)) }
catch { $writer.WriteLine("[read error]") }
}
$writer.Close()
Write-Host ""
Write-Host "Saved to $output"
