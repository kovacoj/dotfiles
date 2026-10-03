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
    sudo apt-get install -y curl direnv fd-find git make gcc ranger ripgrep tmux vim xclip zsh zoxide
    "$repo_dir/scripts/install-neovim.sh"
    "$repo_dir/scripts/install-fzf.sh"
    "$repo_dir/scripts/install-bat.sh"
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

# dotfiles-managed git settings (editor etc.) are included from ~/.gitconfig
git config --global include.path "$repo_dir/config/git/gitconfig" 2>/dev/null || true
link_file "$repo_dir/config/zsh/.zshenv" "$HOME/.zshenv"
link_file "$repo_dir/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$repo_dir/config/vim/.vimrc" "$HOME/.vimrc"
link_file "$repo_dir/config/nvim" "$HOME/.config/nvim"
link_file "$repo_dir/scripts/rgf" "$HOME/.local/bin/rgf"
link_file "$repo_dir/config/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
link_file "$repo_dir/config/ranger/rifle.conf" "$HOME/.config/ranger/rifle.conf"
link_file "$repo_dir/config/ranger/scope.sh" "$HOME/.config/ranger/scope.sh"
link_file "$repo_dir/config/ranger/commands.py" "$HOME/.config/ranger/commands.py"
# opencode.json + tui.json are live per-machine configs the theme switcher
# mutates; copy once (never overwrite an existing live config).
mkdir -p "$HOME/.config/opencode/themes" "$HOME/.config/opencode/prompts"
[ -e "$HOME/.config/opencode/opencode.json" ] || cp "$repo_dir/config/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
[ -e "$HOME/.config/opencode/tui.json" ] || cp "$repo_dir/config/opencode/tui.json" "$HOME/.config/opencode/tui.json"
[ -e "$HOME/.config/opencode/ocv-tui.json" ] || cp "$repo_dir/config/opencode/ocv-tui.json" "$HOME/.config/opencode/ocv-tui.json"
link_file "$repo_dir/config/opencode/package.json" "$HOME/.config/opencode/package.json"
link_file "$repo_dir/config/opencode/themes/system-fun.json" "$HOME/.config/opencode/themes/system-fun.json"
link_file "$repo_dir/config/opencode/themes/latte.json" "$HOME/.config/opencode/themes/latte.json"
link_file "$repo_dir/scripts/ocv.sh" "$HOME/.local/bin/ocv"
link_file "$repo_dir/scripts/rgf" "$HOME/.local/bin/rgf"
link_file "$repo_dir/config/opencode/prompts/multimodal-reader.txt" "$HOME/.config/opencode/prompts/multimodal-reader.txt"

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
