autoload -Uz add-zsh-hook

bindkey -M emacs '^I' expand-or-complete
bindkey -M viins '^I' expand-or-complete
bindkey '^I' expand-or-complete
bindkey -M emacs '^[[9001u' clear-screen
bindkey -M viins '^[[9001u' clear-screen
bindkey '^[[9001u' clear-screen
bindkey '^L' clear-screen
bindkey '^U' kill-whole-line
bindkey '^[[8;5u' backward-kill-word
bindkey '^[[127;5u' backward-kill-word
bindkey '^[[3;5~' kill-word

clip() {
    if command -v clip.exe >/dev/null 2>&1; then
        clip.exe
        return
    fi

    if command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
        return
    fi

    print -u2 'clip: no clipboard command available'
    return 1
}

typeset -g DOTFILES_PENDING_HISTORY=''

zshaddhistory() {
    DOTFILES_PENDING_HISTORY=${1%$'\n'}
    return 1
}

dotfiles_add_successful_history() {
    local exit_status=$?

    if [[ $exit_status -eq 0 && -n "$DOTFILES_PENDING_HISTORY" && "$DOTFILES_PENDING_HISTORY" != ' '* ]]; then
        print -sr -- "$DOTFILES_PENDING_HISTORY"
    fi

    DOTFILES_PENDING_HISTORY=''
}

add-zsh-hook precmd dotfiles_add_successful_history
