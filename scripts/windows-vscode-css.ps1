param(
    [ValidateSet('apply', 'restore')]
    [string]$Action = 'apply',

    [string]$CssPath = (Join-Path $env:USERPROFILE '.vscode\chrome.css')
)

$ErrorActionPreference = 'Stop'
$installRoot = Join-Path $env:ProgramFiles 'Microsoft VS Code'
$relativeWorkbench = 'resources\app\out\vs\code\electron-browser\workbench\workbench.html'
$workbenchPath = Get-ChildItem $installRoot -Directory |
    Sort-Object LastWriteTime -Descending |
    ForEach-Object { Join-Path $_.FullName $relativeWorkbench } |
    Where-Object { Test-Path $_ } |
    Select-Object -First 1

if (-not $workbenchPath) {
    throw "Could not find VS Code's workbench.html under $installRoot"
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
$html = [IO.File]::ReadAllText($workbenchPath)
$sessionPattern = '<!-- !! VSCODE-CUSTOM-CSS-SESSION-ID ([0-9a-fA-F-]+) !! -->'
$sessionMatch = [regex]::Match($html, $sessionPattern)

if ($Action -eq 'restore') {
    if (-not $sessionMatch.Success) {
        Write-Host 'VS Code custom CSS is not currently applied.'
        exit
    }

    $backupPath = Join-Path (Split-Path $workbenchPath) "workbench.$($sessionMatch.Groups[1].Value).bak-custom-css"
    if (-not (Test-Path $backupPath)) {
        throw "Custom CSS backup not found at $backupPath"
    }

    Copy-Item $backupPath $workbenchPath -Force
    Remove-Item $backupPath -Force
    Write-Host 'Restored the original VS Code workbench.'
    exit
}

if (-not (Test-Path $CssPath)) {
    throw "VS Code CSS not found at $CssPath"
}

if ($sessionMatch.Success) {
    $oldBackupPath = Join-Path (Split-Path $workbenchPath) "workbench.$($sessionMatch.Groups[1].Value).bak-custom-css"
    if (Test-Path $oldBackupPath) {
        $html = [IO.File]::ReadAllText($oldBackupPath)
        Remove-Item $oldBackupPath -Force
    }
}

$sessionId = [guid]::NewGuid().ToString()
$backupPath = Join-Path (Split-Path $workbenchPath) "workbench.$sessionId.bak-custom-css"
[IO.File]::WriteAllText($backupPath, $html, $utf8)

$css = [IO.File]::ReadAllText($CssPath)
$html = [regex]::Replace(
    $html,
    '<meta\s+http-equiv="Content-Security-Policy"[\s\S]*?/>',
    ''
)
$injection = @"
<!-- !! VSCODE-CUSTOM-CSS-SESSION-ID $sessionId !! -->
<!-- !! VSCODE-CUSTOM-CSS-START !! -->
<style>
$css
</style>
<!-- !! VSCODE-CUSTOM-CSS-END !! -->
</head>
"@

if (-not $html.Contains('</head>')) {
    Remove-Item $backupPath -Force
    throw 'Could not find </head> in VS Code workbench.html'
}

$html = $html.Replace('</head>', $injection)
[IO.File]::WriteAllText($workbenchPath, $html, $utf8)
Write-Host "Applied VS Code custom CSS from $CssPath"
