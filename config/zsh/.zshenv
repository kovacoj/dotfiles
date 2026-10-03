[ -r "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Tool binaries (~/.local/bin) must win over distro packages; dedupe on every source.
typeset -U path PATH
path=("$HOME/.local/bin" "$path[@]")
