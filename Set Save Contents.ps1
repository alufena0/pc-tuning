param([string]$TargetPath)
$excludedFolders = 'node_modules|\.next|\.git|platforms|plugins|www' # Folders to exclude from both structure and contents
$excludedFiles = 'package-lock\.json' # Individual files to exclude
$textExt = @('.txt','.log','.md','.json','.js','.ts','.jsx','.tsx','.html','.htm','.css','.scss','.xml','.yaml','.yml','.ps1','.bat','.sh','.env','.config','.ini','.toml','.cs','.py','.rb','.php','.java','.c','.cpp','.h','.sql','.prisma','.graphql','.lock','.gitignore','.reg','.vbs','.lua','.rs','.go','.swift','.kt','.dart','.r','.m','.f','.asm','.s','.pl','.pm','.tcl','.awk','.sed','.vim','.conf','.cfg','.properties','.gradle','.cmake','.make','.mk','.dockerfile','.tf','.hcl','.proto','.thrift','.avsc','.mdx','.vue','.svelte','.astro','.sass','.less','.styl','.pug','.ejs','.handlebars','.mustache','.liquid') # Only these extensions will have their contents read

$targetClean = $TargetPath.TrimEnd('\')
$output = Join-Path "$env:USERPROFILE\Desktop" "$((Split-Path $targetClean -Leaf))_dump.txt"
$writer = [System.IO.StreamWriter]::new($output, $false, [System.Text.UTF8Encoding]::new($false))

Write-Host "Listing files..."
$files = @(Get-ChildItem -Path $TargetPath -Recurse -File |
    Where-Object { $_.FullName -notmatch "\\($excludedFolders)\\" } |
    Where-Object { $_.Name -notmatch "^($excludedFiles)$" })

Write-Host "Found $($files.Count) files. Building structure..."
$writer.WriteLine("========== STRUCTURE ==========")
$files | ForEach-Object { $writer.WriteLine($_.FullName) }
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