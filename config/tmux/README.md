# tmux setup

This folder contains the current tmux setup used by the terminal workflow in this repo.

## Core idea

- New terminal instance starts a fresh tmux session.
- That session opens straight into `ranger` in `~/personal`.
- Leaving `ranger` with `Shift+S` drops into a shell in the selected directory.
- The tmux window is renamed to the selected folder name.

This keeps sessions broad and disposable, while window names track the actual folder you decided to work in.

## Files

- `config/tmux/.tmux.conf`: main tmux config.
- `scripts/tmux-ranger-shell.sh`: tmux window launcher for the `ranger -> shell` flow.
- `scripts/tmux-git-status.sh`: status-bar helper for branch and dirty state.
- `config/zsh/tmux-ranger.zsh`: zsh-side startup and `ranger` wrapper.

## Prefix and navigation

- Prefix: `Ctrl+s`
- Send literal `Ctrl+s` to the app inside tmux: `Ctrl+s` then `Ctrl+s`
- Reload tmux config: `prefix + r`
- Move between panes: `Ctrl+h`, `Ctrl+j`, `Ctrl+k`, `Ctrl+l`
- Resize panes: `prefix + H`, `prefix + J`, `prefix + K`, `prefix + L`

## Window and pane workflow

- New ranger-first window: `prefix + c`
- New named session: `prefix + N`
- Split horizontally in current directory: `prefix + %`
- Split vertically in current directory: `prefix + "`
- Kill current pane immediately: `prefix + x`
- Kill current window with confirmation: `prefix + &`
- Kill current session with confirmation: `prefix + X`

### `prefix + c` flow

1. tmux opens a new window with a temporary placeholder name.
2. `ranger` starts in `~/personal`.
3. Navigate to the directory you want.
4. Press `Shift+S` in `ranger`.
5. tmux renames the window to that folder name and opens the shell there.

Manual `ranger` in zsh uses the same chooser behavior, so `Shift+S` also returns you to the selected directory in the current shell, and renames the tmux window when inside tmux.

## Status bar

- Left side: session name.
- Click the left side session name to open tmux's session chooser.
- Right side: current folder name plus git branch and dirty marker when inside a repo.
- Window renaming from applications is disabled intentionally.

That means names stay stable and match the folder-based workflow instead of changing to `python3`, `zsh`, or editor names.

## Sessions

- New terminal instances create a fresh tmux session.
- The startup helper currently chooses the lowest free positive integer as the session name.
- Session naming is still intentionally manual for now until a better naming scheme emerges.

### Create a named session on purpose

- Press `prefix + N`
- tmux prompts for the new session name
- the new session starts in `~/personal` and opens the same `ranger -> Shift+S -> zsh` flow

For already-running sessions, tmux's standard rename prompt is still available with `prefix + $`.

## Restore and resurrection

There are two separate concepts here.

### 1. Restart something tmux still knows about

- Respawn pane: `prefix + R`
- Respawn window: `prefix + W`

These restart the command for a pane or window that tmux still tracks. They are not full historical recovery.

### 2. Restore tmux state after WSL shutdown or reboot

This setup includes:

- TPM
- `tmux-resurrect`
- a lightweight background autosave loop started by tmux

Configured behavior:

- tmux state auto-saves every 30 minutes
- auto-restore on startup is off

Auto-restore is off on purpose because a fresh terminal is supposed to start a fresh `ranger`-first workspace, not unexpectedly reopen an old session. The autosave loop is used instead of `tmux-continuum`'s status-bar hook so pane and window creation stay responsive.

#### Save and restore keys

- Save tmux state now: `prefix + S`
- Restore saved tmux state: `prefix + U`

Use restore after `wsl --shutdown`, distro termination, or Windows reboot.

#### What gets restored well

- sessions
- windows
- panes
- layouts
- working directories
- some program invocations

#### What does not restore perfectly

- live process memory
- REPL state
- unsaved editor buffers
- arbitrary long-running processes exactly as they were

Think of it as workspace reconstruction, not a VM snapshot.

## Recommended workflows

### Normal day-to-day work

1. Open a terminal window.
2. Let it start tmux and `ranger`.
3. Navigate to the folder you want.
4. Press `Shift+S`.
5. Use `prefix + c` for more folder-driven windows.

### Close the terminal window accidentally

- Usually tmux is still alive.
- Open a terminal again and decide whether to keep working fresh or manually attach to the old session.

### WSL shutdown / Windows reboot

1. Open a fresh terminal.
2. tmux starts normally in a fresh session.
3. Press `prefix + U` to restore saved tmux state.

## Notes

- `notes.md` is scratch material from earlier tmux experiments.
- `README.md` describes the current intended setup.
