#!/usr/bin/env bash

set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
backup_dir="${DOTFILES_BACKUP_DIR:-$HOME/.local/state/dotfiles-backups/$(date +%Y%m%d-%H%M%S)}"
install_packages=false

if [ "${1:-}" = "--packages" ]; then
    install_packages=true
elif [ "$#" -ne 0 ]; then
    printf 'Usage: %s [--packages]\n' "$0" >&2
    exit 2
fi

if $install_packages; then
    if ! command -v apt-get >/dev/null 2>&1; then
        printf '%s\n' 'Package installation is currently supported only on apt-based systems.' >&2
        exit 1
    fi
    sudo apt-get update
    sudo apt-get install -y curl direnv fd-find git make gcc ranger ripgrep tmux vim xclip zsh
    "$repo_dir/scripts/install-neovim.sh"
fi

link_file() {
    source=$1
    target=$2

    mkdir -p -- "$(dirname -- "$target")"
    if [ -L "$target" ] && [ "$(readlink -f -- "$target")" = "$(readlink -f -- "$source")" ]; then
        printf 'unchanged %s\n' "$target"
        return
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
        relative_target=${target#"$HOME"/}
        mkdir -p -- "$backup_dir/$(dirname -- "$relative_target")"
        mv -- "$target" "$backup_dir/$relative_target"
        printf 'backed up %s\n' "$target"
    fi

    ln -s -- "$source" "$target"
    printf 'linked    %s\n' "$target"
}

link_file "$repo_dir/config/zsh/.zshrc" "$HOME/.zshrc"
link_file "$repo_dir/config/zsh/.zshenv" "$HOME/.zshenv"
link_file "$repo_dir/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$repo_dir/config/vim/.vimrc" "$HOME/.vimrc"
link_file "$repo_dir/config/nvim" "$HOME/.config/nvim"
link_file "$repo_dir/config/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
link_file "$repo_dir/config/ranger/commands.py" "$HOME/.config/ranger/commands.py"
link_file "$repo_dir/config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
link_file "$repo_dir/config/opencode/tui.json" "$HOME/.config/opencode/tui.json"
link_file "$repo_dir/config/opencode/package.json" "$HOME/.config/opencode/package.json"
link_file "$repo_dir/config/opencode/themes/system-fun.json" "$HOME/.config/opencode/themes/system-fun.json"

if [ ! -d "$HOME/.oh-my-zsh/.git" ]; then
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

autosuggestions_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$autosuggestions_dir/.git" ]; then
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions_dir"
fi

tpm_dir="$HOME/.tmux/plugins/tpm"
if [ ! -d "$tpm_dir/.git" ]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
fi

if command -v npm >/dev/null 2>&1; then
    if ! command -v tree-sitter >/dev/null 2>&1; then
        npm install --global --prefix "$HOME/.local" tree-sitter-cli@0.27.0
    fi
    npm install --prefix "$HOME/.config/opencode" --ignore-scripts
fi

if [ -d "$backup_dir" ]; then
    printf '\nExisting files were saved under %s\n' "$backup_dir"
fi
printf '%s\n' 'Dotfiles installed. Start a new zsh session to load them.'
