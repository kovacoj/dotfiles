param(
    [ValidateSet('apply', 'restore')]
    [string]$Action = 'apply',

    [ValidateRange(16, 24)]
    [int]$Height = 19
)

$ErrorActionPreference = 'Stop'
$metricsPath = 'HKCU:\Control Panel\Desktop\WindowMetrics'
$backupDir = Join-Path $env:LOCALAPPDATA 'dotfiles'
$backupPath = Join-Path $backupDir 'window-metrics-backup.json'
$names = 'CaptionHeight', 'CaptionWidth', 'PaddedBorderWidth'

if ($Action -eq 'restore') {
    if (-not (Test-Path $backupPath)) {
        throw "No title-bar backup found at $backupPath"
    }

    $backup = Get-Content $backupPath -Raw | ConvertFrom-Json
    foreach ($name in $names) {
        Set-ItemProperty $metricsPath $name ([string]$backup.$name)
    }
    Write-Host 'Restored Windows title-bar metrics. Sign out and back in to apply.'
    exit
}

if (-not (Test-Path $backupPath)) {
    New-Item $backupDir -ItemType Directory -Force | Out-Null
    $metrics = Get-ItemProperty $metricsPath
    $backup = [ordered]@{}
    foreach ($name in $names) {
        $backup[$name] = [string]$metrics.$name
    }
    $backup | ConvertTo-Json | Set-Content $backupPath -Encoding UTF8
}

$captionSize = [string](-15 * $Height)
Set-ItemProperty $metricsPath CaptionHeight $captionSize
Set-ItemProperty $metricsPath CaptionWidth $captionSize
Set-ItemProperty $metricsPath PaddedBorderWidth '0'

Write-Host "Set Windows title bars to $Height logical pixels. Sign out and back in to apply."
