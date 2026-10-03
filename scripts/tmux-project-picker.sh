#!/usr/bin/env bash
# prefix+p: fuzzy project/workspace picker.
# Candidates: zoxide-learned dirs, then ~/personal + ~/projects folders.
# Selecting one creates or switches to a tmux session rooted there.
set -euo pipefail

roots=("$HOME/personal" "$HOME/projects")

candidates=$(
  {
    zoxide query -l 2>/dev/null || true
    for r in "${roots[@]}"; do
      [ -d "$r" ] || continue
      find "$r" -mindepth 1 -maxdepth 2 -type d -not -path '*/.git' 2>/dev/null
    done
  } | awk 'NF && !seen[$0]++'
)

[ -n "$candidates" ] || exit 0

selected=$(printf '%s\n' "$candidates" | fzf --layout=reverse --prompt='project> ' || true)
[ -n "$selected" ] || exit 0

# session name from dir: stable, disambiguated on basename collisions
name=$(basename "$selected" | tr '. ' '__')
if tmux has-session -t "=$name" 2>/dev/null; then
  current_hd=$(tmux display-message -p -t "=$name" "#{pane_current_path}" 2>/dev/null || true)
  if [ "$current_hd" != "$selected" ]; then
    parent=$(basename "$(dirname "$selected")" | tr '. ' '__')
    name="${parent}-${name}"
  fi
fi

if ! tmux has-session -t "=$name" 2>/dev/null; then
  tmux new-session -d -s "$name" -c "$selected"
fi
tmux switch-client -t "=$name"
