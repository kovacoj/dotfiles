param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dark', 'light')]
    [string]$Mode
)

$ErrorActionPreference = 'Stop'
$path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
$value = [int]($Mode -eq 'light')
Set-ItemProperty $path AppsUseLightTheme $value
Set-ItemProperty $path SystemUsesLightTheme $value

# Notify running apps so the registry change takes effect immediately.
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public class ThemeNotify {
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern IntPtr SendMessageTimeout(
        IntPtr h, uint m, UIntPtr w, string l, uint f, uint t, out UIntPtr r);
}
'@
$result = [UIntPtr]::Zero
[void][ThemeNotify]::SendMessageTimeout(
    [IntPtr]0xffff, 0x001a, [UIntPtr]::Zero, 'ImmersiveColorSet', 2, 5000, [ref]$result)
