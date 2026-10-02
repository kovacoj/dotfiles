#!/usr/bin/env bash

set -eu

version=0.12.5
archive=nvim-linux-x86_64.tar.gz
checksum=bce0f56eda1f1b1db6eee8f4133d7a38813ea07933837dd1777411ca384c6875
install_dir="$HOME/.local/opt/nvim-$version"
download="${TMPDIR:-/tmp}/$archive"

if [ "$(uname -m)" != x86_64 ]; then
    printf '%s\n' 'This installer currently supports x86_64 Linux only.' >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"
curl -fL "https://github.com/neovim/neovim/releases/download/v$version/$archive" -o "$download"
printf '%s  %s\n' "$checksum" "$download" | sha256sum --check

rm -rf "$install_dir"
mkdir -p "$install_dir"
tar -xzf "$download" -C "$install_dir" --strip-components=1
ln -sfn "$install_dir/bin/nvim" "$HOME/.local/bin/nvim"

printf 'Installed Neovim %s at %s\n' "$version" "$install_dir"
