#!/usr/bin/env bash

set -eu

version=0.65.1
archive="lazygit_${version}_linux_x86_64.tar.gz"
checksum=02beacbcda0fa342e50ae3480ba8147307353af3fb28e1d5f790e02329c201a6
install_dir="$HOME/.local/opt/lazygit-$version"
download="${TMPDIR:-/tmp}/$archive"

if [ "$(uname -m)" != x86_64 ]; then
    printf '%s\n' 'This installer currently supports x86_64 Linux only.' >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin"
curl -fL "https://github.com/jesseduffield/lazygit/releases/download/v$version/$archive" -o "$download"
printf '%s  %s\n' "$checksum" "$download" | sha256sum --check

rm -rf "$install_dir"
mkdir -p "$install_dir"
tar -xzf "$download" -C "$install_dir" lazygit
ln -sfn "$install_dir/lazygit" "$HOME/.local/bin/lazygit"

printf 'Installed lazygit %s at %s\n' "$version" "$install_dir"
