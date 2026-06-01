#!/usr/bin/env bash

set -euo pipefail

session_name=${1:-}

[ -n "$session_name" ] || exit 0

tmux new-session -d -s "$session_name" -c "$HOME/personal" "$HOME/dotfiles/scripts/tmux-ranger-shell.sh"
tmux switch-client -t "$session_name"
