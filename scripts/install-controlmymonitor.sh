#!/usr/bin/env bash

set -eu

powershell=/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
if [ ! -x "$powershell" ]; then
    exit 0
fi

"$powershell" -NoProfile -NonInteractive -Command '
$ErrorActionPreference = "Stop"
$target = Join-Path $HOME ".local\bin\ControlMyMonitor.exe"
if (Test-Path $target) {
    Write-Output "unchanged $target"
    exit 0
}

$archive = Join-Path $env:TEMP "controlmymonitor.zip"
$staging = Join-Path $env:TEMP "controlmymonitor"
try {
    Invoke-WebRequest "https://www.nirsoft.net/utils/controlmymonitor.zip" -OutFile $archive
    Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue
    Expand-Archive $archive -DestinationPath $staging
    New-Item (Split-Path $target) -ItemType Directory -Force | Out-Null
    Copy-Item (Join-Path $staging "ControlMyMonitor.exe") $target
    Write-Output "installed $target"
} finally {
    Remove-Item $archive -Force -ErrorAction SilentlyContinue
    Remove-Item $staging -Recurse -Force -ErrorAction SilentlyContinue
}
'
