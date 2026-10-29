#!/usr/bin/env bash

set -eu

version=12.9
repo="https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64"
install_dir="$HOME/.local/opt/cuda-$version"
download_dir="${TMPDIR:-/tmp}/cuda-debs"

if [ "$(uname -m)" != x86_64 ]; then
    printf '%s\n' 'This installer currently supports x86_64 Linux only.' >&2
    exit 1
fi

# Pinned packages (nvcc, cudart, cudart-dev, crt, nvvm, cccl, cuobjdump, nvdisasm)
packages=(
    "cuda-nvcc-12-9_12.9.86-1_amd64.deb 66c11ad4fba8c12c44a1fec346c5125011e2ed519b98a787966dda0df9043b45"
    "cuda-cudart-12-9_12.9.79-1_amd64.deb 2649df5457dcf9a741f979b5c71e09aba563a11ef1c84a0725c3fe7a37625e6e"
    "cuda-cudart-dev-12-9_12.9.79-1_amd64.deb e3ca8561b6bec2a92928ebafd68ed9278bf66d5521a2584d6370792386b247c0"
    "cuda-crt-12-9_12.9.86-1_amd64.deb 364c82d5fd53b6687aca004c4583fd119a98e0fe72798d88b0fdedc56ad5aecf"
    "cuda-nvvm-12-9_12.9.86-1_amd64.deb 679b7fa53d30dcb7d2f5f55107274fa502ff18071c6c1235cb941fcbe22a1403"
    "cuda-cccl-12-9_12.9.27-1_amd64.deb 255b92bd5e09cd10aedaf098d1ee0f66ca1a9062efe96e2e1f385583ddf18c73"
    "cuda-cuobjdump-12-9_12.9.82-1_amd64.deb c2442f96785b9d06818e4d4edc1a2612227da14450c2ac704db7c97239116782"
    "cuda-nvdisasm-12-9_12.9.88-1_amd64.deb e2d186f399f4d8c2740b59bffde397b8a1bb5d344cfdf91355e7af10e3a9f3db"
)

mkdir -p "$download_dir" "$HOME/.local/opt"

for entry in "${packages[@]}"; do
    file="${entry%% *}"
    checksum="${entry##* }"
    path="$download_dir/$file"

    if [ ! -f "$path" ]; then
        curl -fL "$repo/$file" -o "$path"
    fi
    printf '%s  %s\n' "$checksum" "$path" | sha256sum --check
done

stage="$HOME/.local/opt/.cuda-$version-stage"
rm -rf "$stage" "$install_dir"
mkdir -p "$stage"

for entry in "${packages[@]}"; do
    dpkg-deb -x "$download_dir/${entry%% *}" "$stage"
done

mv "$stage/usr/local/cuda-$version" "$install_dir"
rm -rf "$stage"
ln -sfn "$install_dir" "$HOME/.local/opt/cuda"

printf 'Installed CUDA %s toolkit at %s (no GPU required for compilation)\n' "$version" "$install_dir"
printf 'Add ~/.local/opt/cuda/bin to PATH (see .zshrc)\n'
