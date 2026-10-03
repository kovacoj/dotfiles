#!/usr/bin/env bash

set -euo pipefail

session_name=${1:-}

[ -n "$session_name" ] || exit 0

start_dir="${DOTFILES_START_DIR:-}"
if [ -z "$start_dir" ]; then
  [ -d "$HOME/personal" ] && start_dir="$HOME/personal" || start_dir="$HOME"
fi

tmux new-session -d -s "$session_name" -c "$start_dir" "$HOME/dotfiles/scripts/tmux-ranger-shell.sh"
tmux switch-client -t "$session_name"
