#!/usr/bin/env bash

set -eu

version=0.26.1
archive="bat-v$version-x86_64-unknown-linux-musl.tar.gz"
checksum=0dcd8ac79732c0d5b136f11f4ee00e581440e16a44eab5b3105b611bbf2cf191
install_dir="$HOME/.local/opt/bat-$version"
download="${TMPDIR:-/tmp}/$archive"

if [ "$(uname -m)" != x86_64 ]; then
    printf '%s\n' 'This installer currently supports x86_64 Linux only.' >&2
    exit 1
fi

mkdir -p "$HOME/.local/bin"
curl -fL "https://github.com/sharkdp/bat/releases/download/v$version/$archive" -o "$download"
printf '%s  %s\n' "$checksum" "$download" | sha256sum --check

rm -rf "$install_dir"
mkdir -p "$install_dir"
tar -xzf "$download" -C "$install_dir" --strip-components=1
ln -sfn "$install_dir/bat" "$HOME/.local/bin/bat"

printf 'Installed bat %s at %s\n' "$version" "$install_dir"
