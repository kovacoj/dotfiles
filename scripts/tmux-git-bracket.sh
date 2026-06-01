#!/usr/bin/env bash

set -euo pipefail

side=${1:-}
path=${2:-}

[ -n "$side" ] || exit 0
[ -n "$path" ] || exit 0

branch=$("$HOME/dotfiles/scripts/tmux-git-status.sh" "$path") || exit 0
[ -n "$branch" ] || exit 0

case "$side" in
  open)
    printf '('
    ;;
  close)
    printf ')'
    ;;
esac
