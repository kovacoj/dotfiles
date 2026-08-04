# Dotfiles

Configuration for zsh, tmux, Vim, ranger, and OpenCode.

## Install

```sh
./install.sh
```

The installer symlinks managed files into the home directory. Existing files
are moved to a timestamped directory under `~/.local/state/dotfiles-backups`,
and rerunning the installer leaves correct links unchanged.

On Ubuntu or another apt-based system, install the core packages too:

```sh
./install.sh --packages
```

Set `DOTFILES_START_DIR` to choose the directory used for new tmux sessions.
It defaults to `~/personal`, then falls back to `$HOME` if that directory does
not exist. Set `DOTFILES_DISABLE_TMUX_AUTOSTART=1` to disable tmux autostart.
