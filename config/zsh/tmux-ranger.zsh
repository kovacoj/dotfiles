# Repo-backed ranger wrapper so quitting with Shift+S returns to the
# selected directory in the same shell, and keeps tmux window names aligned.
ranger_cd() {
    local start_dir tmpfile chosen_dir exit_code window_name

    start_dir="${1:-$PWD}"
    tmpfile=$(mktemp "${TMPDIR:-/tmp}/ranger-cwd.XXXXXX") || return 1

    command ranger --choosedir="$tmpfile" -- "$start_dir"
    exit_code=$?

    if [ -r "$tmpfile" ]; then
        chosen_dir=$(<"$tmpfile")
        if [ -n "$chosen_dir" ] && [ -d "$chosen_dir" ]; then
            builtin cd -- "$chosen_dir"

            if [ -n "$TMUX" ]; then
                window_name=$(basename "${chosen_dir%/}")
                command tmux rename-window "${window_name:-/}"
            fi
        fi
    fi

    rm -f -- "$tmpfile"
    return $exit_code
}

ranger() {
    ranger_cd "$@"
}

autostart_tmux_ranger() {
    local session_name

    [[ $- == *i* ]] || return
    [ -n "$TMUX" ] && return
    [ -n "$INSIDE_EMACS" ] && return
    [ -n "$EMACS" ] && return
    [ -n "$VIM" ] && return
    [ -n "$INTELLIJ_ENVIRONMENT_READER" ] && return
    [ -n "$ZED_TERM" ] && return
    [ -n "${DOTFILES_DISABLE_TMUX_AUTOSTART:-}" ] && return

    session_name=$(command tmux list-sessions -F '#{session_name}' 2>/dev/null | awk 'BEGIN { n = 1 } /^[0-9]+$/ { used[$1] = 1 } END { while (used[n]) n++; print n }')
    exec command tmux new-session -s "$session_name" -c "$HOME/personal" "$HOME/dotfiles/scripts/tmux-ranger-shell.sh"
}

autostart_tmux_ranger
