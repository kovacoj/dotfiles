#!/usr/bin/env bash

set -euo pipefail

start_dir=${PWD}
choice_file=$(mktemp)

if [ -n "${TMUX:-}" ]; then
  initial_name=$(tmux display-message -p '#I' 2>/dev/null || true)
  if [ -n "$initial_name" ]; then
    tmux rename-window "$initial_name"
  fi
fi

cleanup() {
  rm -f "$choice_file"
}

trap cleanup EXIT

ranger --choosedir="$choice_file" "$start_dir"

target_dir=$start_dir
if [ -s "$choice_file" ]; then
  target_dir=$(<"$choice_file")
fi

if [ -d "$target_dir" ]; then
  cd "$target_dir"

  if [ -n "${TMUX:-}" ]; then
    window_name=$(basename "${target_dir%/}")
    tmux rename-window "${window_name:-/}"
  fi
fi

exec "${SHELL:-/bin/sh}" -i
