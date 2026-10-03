#!/usr/bin/env bash

set -eu

version=0.74.4
archive="fzf-$version-linux_amd64.tar.gz"
checksum=05e6813a337cc722c3ed07e54a764b75cc5d671e2e60459db0ba696ee5fa7504
install_dir="$HOME/.local/opt/fzf-$version"
download="${TMPDIR:-/tmp}/$archive"

if [ "$(uname -m)" != x86_64 ]; then
    printf '%s\n' 'This installer currently supports x86_64 Linux only.' >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin"
curl -fL "https://github.com/junegunn/fzf/releases/download/v$version/$archive" -o "$download"
printf '%s  %s\n' "$checksum" "$download" | sha256sum --check

rm -rf "$install_dir"
mkdir -p "$install_dir"
tar -xzf "$download" -C "$install_dir"
ln -sfn "$install_dir/fzf" "$HOME/.local/bin/fzf"

printf 'Installed fzf %s at %s\n' "$version" "$install_dir"
