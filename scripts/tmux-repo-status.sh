#!/usr/bin/env bash
# One-shot tmux status segment: "name(branch*)" with the pane's dir basename and
# its git branch/state, so the bar runs ONE command per redraw instead of three.
# Usage: tmux-repo-status.sh <path> <accent_fg> <danger_fg>
set -euo pipefail

path=${1:-}
accent=${2:-'#5fd7ff'}
danger=${3:-'#ff5f87'}

[ -n "$path" ] || exit 0
[ -d "$path" ] || exit 0

name=$(basename "$path")

printf '#[fg=%s]%s' "$accent" "$name"

if git -C "$path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  status_output=$(git -C "$path" status --porcelain=2 --branch 2>/dev/null) || status_output=''
  branch=''
  dirty=''
  if [ -n "$status_output" ]; then
    while IFS= read -r line; do
      case "$line" in
        '# branch.head '*) branch=${line#'# branch.head '} ;;
        '1 '*|'2 '*|'u '*|'? '*|'! '*)
          [ -z "$dirty" ] && dirty='*'
          ;;
      esac
    done <<EOF
$status_output
EOF
  fi
  if [ -n "$branch" ] && [ "$branch" != '(detached)' ]; then
    printf '(#[fg=%s]%s%s#[fg=%s])' "$danger" "$(printf '%s' "$branch" | sed 's/^ //')" "$dirty" "$accent"
  fi
fi

printf ' '
