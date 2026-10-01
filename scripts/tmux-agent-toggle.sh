#!/usr/bin/env bash
# Toggle a persistent "agent drawer" terminal pane at the bottom of the
# current tmux window (VS Code integrated-terminal style).
#
# Usage (normally from .tmux.conf):
#   tmux-agent-toggle.sh <cur_pane_id> <owner_window_id> <cwd>
#
# Invariant: the drawer pane is never killed while toggling. Hiding moves it
# into a detached "__agent_park" session (break-pane + move-window); showing
# joins the same pane ID back underneath the invoking pane.

set -euo pipefail

cur_pane="${1:?usage: tmux-agent-toggle.sh <pane_id> <window_id> <cwd>}"
owner="${2:?usage: tmux-agent-toggle.sh <pane_id> <window_id> <cwd>}"
cwd="${3:?usage: tmux-agent-toggle.sh <pane_id> <window_id> <cwd>}"

park="__agent_park"
drawer_name="__agent"

pane_alive() {
    tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qx -- "$1"
}

# Fail fast on a bogus owner window instead of misbehaving downstream.
owner_sess="$(tmux display-message -p -t "$owner" '#{session_name}' 2>/dev/null)" || {
    echo "tmux-agent-toggle: no such window: $owner" >&2
    exit 1
}

# Never toggle from inside the parked drawer itself.
if [[ "$owner_sess" == "$park" ]] ||
   [[ "$(tmux display-message -p -t "$owner" '#{window_name}')" == "$drawer_name" ]]; then
    tmux display-message -t "$cur_pane" 'agent drawer: already inside the drawer'
    exit 0
fi

agent_pane="$(tmux show-options -wqt "$owner" -qv @agent_pane 2>/dev/null || true)"

# ---------------------------------------------------------------- no drawer --
if [[ -z "$agent_pane" ]] || ! pane_alive "$agent_pane"; then
    # Drop stale state.
    if [[ -n "$agent_pane" ]]; then
        tmux set-option -uwt "$owner" @agent_pane 2>/dev/null || true
    fi

    # Kill parked drawers that no window claims anymore (owner window died,
    # server restored by resurrect, etc.). Only touch our parked windows.
    if tmux has-session -t "=$park" 2>/dev/null; then
        declare -A referenced=()
        while IFS= read -r wid; do
            p="$(tmux show-options -wqt "$wid" -qv @agent_pane 2>/dev/null || true)"
            [[ -n "$p" ]] && referenced["$p"]=1
        done < <(tmux list-windows -a -F '#{window_id}')

        while read -r wid wname; do
            p="$(tmux list-panes -t "$wid" -F '#{pane_id}' 2>/dev/null | head -n1 || true)"
            if [[ "$wname" == "$drawer_name" && -n "$p" && -z "${referenced[$p]:-}" ]]; then
                tmux kill-window -t "$wid" 2>/dev/null || true
            fi
        done < <(tmux list-windows -t "$park" -F '#{window_id} #{window_name}' 2>/dev/null || true)
    fi

    # Create a fresh drawer below the invoking pane.
    agent_pane="$(tmux split-window -v -l 40% -c "$cwd" -P -F '#{pane_id}' -t "$cur_pane")"
    tmux set-option -wt "$owner" @agent_pane "$agent_pane"
    tmux select-pane -t "$agent_pane"
    exit 0
fi

# ------------------------------------------------- resolve attach anchor --
# Attach below the invoking pane; if invoked from the drawer itself, attach
# below the first other pane in the window instead.
anchor="$cur_pane"
if [[ "$cur_pane" == "$agent_pane" ]]; then
    anchor="$(tmux list-panes -t "$owner" -F '#{pane_id}' | grep -vx "$agent_pane" | head -n1 || true)"
fi

agent_window="$(tmux display-message -p -t "$agent_pane" '#{window_id}')"

if [[ "$agent_window" == "$owner" ]]; then
    # ------------------------------------------------------ visible -> hide --
    if [[ -z "$anchor" ]]; then
        tmux display-message -t "$cur_pane" 'agent drawer: refusing to hide the only pane in this window'
        exit 0
    fi
    win="$(tmux break-pane -dP -F '#{window_id}' -n "$drawer_name" -s "$agent_pane")"
    tmux has-session -t "=$park" 2>/dev/null || \
        tmux new-session -d -s "$park" -n holder 'exec sleep infinity'
    tmux move-window -s "$win" -t "$park:"
    tmux select-pane -t "$anchor"
else
    # ------------------------------------------------------ hidden -> show --
    tmux join-pane -v -l 40% -s "$agent_pane" -t "${anchor:-$owner}"
    tmux select-pane -t "$agent_pane"
fi
