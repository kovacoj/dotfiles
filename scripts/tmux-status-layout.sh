#!/usr/bin/env bash

set -euo pipefail

session=${1:-}
if [ -z "$session" ]; then
  while IFS= read -r attached_session; do
    "$0" "$attached_session"
  done < <(tmux list-clients -F '#{session_id}' 2>/dev/null)
  exit 0
fi

# A session has one status layout, so accommodate its narrowest attached client.
width=''
while IFS= read -r client_width; do
  if [ -z "$width" ] || (( client_width < width )); then
    width=$client_width
  fi
done < <(tmux list-clients -t "$session" -F '#{client_width}' 2>/dev/null)
[ -n "$width" ] || exit 0

session_name=$(tmux display-message -p -t "$session" '#{session_name}')
left_width=$((${#session_name} + 20))

pane_path=$(tmux display-message -p -t "$session" '#{pane_current_path}')
right=$(
  "$HOME/dotfiles/scripts/tmux-repo-status.sh" \
    "$pane_path" '#c084fc' '#ff5f87' 2>/dev/null || true
)
while [[ $right =~ ^(.*)#\[[^]]*\](.*)$ ]]; do
  right=${BASH_REMATCH[1]}${BASH_REMATCH[2]}
done
right_width=${#right}

windows_width=0
window_count=0
while IFS= read -r window_name; do
  ((windows_width += ${#window_name})) || true
  ((window_count += 1)) || true
done < <(tmux list-windows -t "$session" -F '#{window_name}')
(( window_count > 1 )) && ((windows_width += (window_count - 1) * 3))

side_width=$left_width
(( right_width > side_width )) && side_width=$right_width
required_width=$((windows_width + 2 * side_width + 2))

if (( width < required_width )); then
  tmux set-option -qt "$session" status-left ''
  tmux set-option -qt "$session" status-right ''
  tmux set-option -qt "$session" status 2
else
  tmux set-option -qt "$session" status on
  tmux set-option -qut "$session" status-left 2>/dev/null || true
  tmux set-option -qut "$session" status-right 2>/dev/null || true
fi
