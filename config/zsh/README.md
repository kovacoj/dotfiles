# zsh setup

This folder contains the zsh configuration used from `~/.zshrc` and `~/.zshenv`.

## Files

- `.zshrc`: main shell entrypoint
- `.zshenv`: early zsh environment setup
- `shell-experience.zsh`: keybindings, clipboard helper, history behavior
- `tmux-ranger.zsh`: tmux autostart and ranger integration

## Notes

- `direnv` is enabled from `.zshrc` for per-project environment variables.
- This is mainly used for work/company projects where API keys and similar
  secrets should only exist inside that project shell, not globally.
- Ranger is launched through the normal config path, with local overrides kept
  in `config/ranger/rc.conf`.

## Terminal habits

- `command | clip`: send output to the clipboard helper from zsh
- `nohup command >file 2>&1 &`: keep jobs running after the shell exits
- `command > /dev/null 2>&1 &`: fully silence a background job
- `Ctrl+z`, then `bg`, then `disown`: push a running foreground job into the background
- `command 2>/dev/null`: hide only stderr
- `command >/dev/null 2>&1`: hide both stdout and stderr
