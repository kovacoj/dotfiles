#!/usr/bin/env bash

set -euo pipefail

socket_path=${1:-}
interval_seconds=${2:-900}
default_save_script=${HOME}/.tmux/plugins/tmux-resurrect/scripts/save.sh

[ -n "$socket_path" ] || exit 1

lock_name=$(printf '%s' "$socket_path" | tr '/:' '__')
lock_dir="/tmp/opencode/tmux-resurrect-autosave-${lock_name}.lock"

cleanup() {
  rmdir "$lock_dir" >/dev/null 2>&1 || true
}

if ! mkdir "$lock_dir" >/dev/null 2>&1; then
  exit 0
fi

trap cleanup EXIT

while tmux -S "$socket_path" list-sessions >/dev/null 2>&1; do
  sleep "$interval_seconds"

  save_script=$(tmux -S "$socket_path" show-options -gqv '@resurrect-save-script-path' 2>/dev/null || true)
  if [ -z "$save_script" ]; then
    save_script=$default_save_script
  fi

  [ -x "$save_script" ] || continue

  "$save_script" quiet >/dev/null 2>&1 || true
done
