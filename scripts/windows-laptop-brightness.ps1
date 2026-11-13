$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$Value = [int]$env:BRIGHTNESS_VALUE

Get-CimInstance -Namespace root/wmi -ClassName WmiMonitorBrightnessMethods |
    Where-Object Active |
    ForEach-Object {
        Invoke-CimMethod -InputObject $_ -MethodName WmiSetBrightness -Arguments @{
            Brightness = [byte]$Value
            Timeout = 1
        } | Out-Null
    }
