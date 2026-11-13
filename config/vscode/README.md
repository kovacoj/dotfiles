# VS Code window controls

`chrome.css` replaces VS Code's right-side window controls with the same
macOS-style controls used by Firefox. The live copy is stored at
`%USERPROFILE%\.vscode\chrome.css`.

VS Code 1.142 and newer must render the controls itself rather than use
Electron's native Windows overlay:

```json
"window.controlsStyle": "custom"
```

Run `scripts/windows-vscode-css.ps1` from an elevated PowerShell session after
VS Code updates. Restore the original workbench with:

```powershell
scripts\windows-vscode-css.ps1 -Action restore
```

The script stores a version-specific backup beside VS Code's `workbench.html`.
