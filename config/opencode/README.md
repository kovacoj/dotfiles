# opencode setup

This folder tracks the user-managed OpenCode configuration that lives under
`~/.config/opencode`.

Tracked here:

- `opencode.json`: global OpenCode config
- `tui.json`: TUI theme selection
- `themes/`: custom repo-backed themes
- `package.json`: plugin/runtime dependency declaration used in `~/.config/opencode`
- `.gitignore`: keeps generated files out of the live config directory

Not tracked here:

- `node_modules/`
- other generated runtime files

## Windows Terminal note

For WSL + OpenCode multiline input, Windows Terminal on the Windows side has a
custom `shift+enter` binding that sends a literal newline.

Windows-side file:

- `C:\Users\z005561w\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

Relevant entries:

```json
"actions": [
  {
    "command": {
      "action": "sendInput",
      "input": "\u001b[13;2u"
    },
    "id": "User.sendInput.DFCDAF06"
  }
],
"keybindings": [
  {
    "id": "User.sendInput.DFCDAF06",
    "keys": "shift+enter"
  }
]
```

If multiline input stops working on another machine, recreate that Windows
Terminal binding and restart Windows Terminal.
