# Dotfiles

Configuration for zsh, tmux, Vim, Neovim, ranger, and OpenCode.

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

This installs the current pinned Neovim release under `~/.local/opt` because
Ubuntu's packaged Neovim is too old for the configured plugins.

Set `DOTFILES_START_DIR` to choose the directory used for new tmux sessions.
It defaults to `~/personal`, then falls back to `$HOME` if that directory does
not exist. Set `DOTFILES_DISABLE_TMUX_AUTOSTART=1` to disable tmux autostart.

## Windows title bars

From WSL, make classic Windows title bars and caption buttons more compact:

```sh
powershell=/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
"$powershell" -NoProfile -Command "& { $(<scripts/windows-titlebar.ps1) }"
```

The script saves the original registry values before changing them. Restore
those values by adding `-Action restore` after the closing `}` inside the
command string. Sign out of Windows and back in after either command. Apps that
draw their own title bars may ignore these settings.

Firefox draws its own title and tab bars. Its compact Acrylic chrome and macOS-
style controls are stored under `config/firefox`. Copy `user.js` into the active
Firefox profile and copy `userChrome.css` plus `titlebuttons` into that profile's
`chrome` directory, then fully restart Firefox. Remove the copied files to
restore Firefox defaults.

Real desktop-backed Acrylic is provided by the Microsoft Store build of Mica
For Everyone. `config/windows/mica-for-everyone.json` disables global changes
and applies Acrylic only to `firefox.exe`.
