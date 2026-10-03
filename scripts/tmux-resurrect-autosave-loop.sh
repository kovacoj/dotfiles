#!/usr/bin/env bash

set -euo pipefail

socket_path=${1:-}
interval_seconds=${2:-900}
default_save_script=${HOME}/.tmux/plugins/tmux-resurrect/scripts/save.sh

[ -n "$socket_path" ] || exit 1

lock_name=$(printf '%s' "$socket_path" | tr '/:' '__')
lock_base="${XDG_RUNTIME_DIR:-/tmp}/dotfiles-tmux"
mkdir -p "$lock_base"
lock_file="$lock_base/tmux-resurrect-autosave-${lock_name}.lock"

# flock-based single-instance lock; survives SIGKILL, no stale lock dirs.
exec 9>"$lock_file"
flock -n 9 || exit 0

while tmux -S "$socket_path" list-sessions >/dev/null 2>&1; do
  sleep "$interval_seconds"

  save_script=$(tmux -S "$socket_path" show-options -gqv '@resurrect-save-script-path' 2>/dev/null || true)
  if [ -z "$save_script" ]; then
    save_script=$default_save_script
  fi

  [ -x "$save_script" ] || continue

  "$save_script" quiet >/dev/null 2>&1 || true
done
