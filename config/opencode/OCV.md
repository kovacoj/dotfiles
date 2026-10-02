# OpenCode Vim trial

`ocv` provides native cursor navigation and visual selection over conversation
history. The installed trial version is `1.18.34-ocv.4.11`.

- Binary: `~/.ocv/bin/ocv`
- Launcher: `~/.local/bin/ocv` links to `scripts/ocv.sh`
- Extra TUI settings: `config/opencode/ocv-tui.json`
- Launch: `ocv`, or `ocv --session SESSION_ID` to reopen a conversation
- Update: `ocv update`

The launcher adds fork-specific settings with `OPENCODE_TUI_CONFIG`. It uses
the existing OpenCode global configuration, credentials, themes, plugins, and
session database. Enter submits prompts and the initial prompt mode is insert.

## Conversation selection

In tmux, `Ctrl+s [` sends `Ctrl+Alt+v` when the foreground command is `ocv`.
Otherwise, it opens normal tmux copy-mode. Outside tmux, use `Ctrl+Alt+v` or
the default OpenCode leader followed by `v` (`Ctrl+x v`).

- `h/j/k/l`: move the cursor
- `Ctrl+u` / `Ctrl+d`: scroll through history
- `v` / `V`: character-wise / line-wise visual selection
- `y`: yank; system clipboard integration is enabled
- `Enter`: copy a selection to the system clipboard
- `q`: leave conversation copy-mode and return to the bottom

Upstream project: https://github.com/leohenon/opencode/tree/ocv
