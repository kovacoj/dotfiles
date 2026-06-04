# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# todo: refactor and modularize
# # XDG Base Directory Specification
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_STATE_HOME="$HOME/.local/state"
export PATH="/usr/local/bin/tesseract:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    tmux
    zsh-autosuggestions
#    vi-mode
)
#  fast-syntax-highlighting zsh-autocompletions)

# Keep a plain-shell fallback directory only when tmux autostart is
# intentionally disabled for this shell.
if [ -z "$TMUX" ] && [ -n "${DOTFILES_DISABLE_TMUX_AUTOSTART:-}" ]; then
    cd ~/projects
fi

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Replace these lines in your .zshrc:
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
    ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# Tmux plugin configuration (add this before source $ZSH/oh-my-zsh.sh)
ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=true
ZSH_TMUX_FIXTERM=true
# ZSH_TMUX_THEME="powerline"

source $ZSH/oh-my-zsh.sh

[ -f "$HOME/dotfiles/config/zsh/tmux-ranger.zsh" ] && source "$HOME/dotfiles/config/zsh/tmux-ranger.zsh"
[ -f "$HOME/dotfiles/config/zsh/shell-experience.zsh" ] && source "$HOME/dotfiles/config/zsh/shell-experience.zsh"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

export CDPATH=".:$HOME:$HOME/projects"
setopt AUTO_CD          # Just type directory name to cd into it
setopt CDABLE_VARS      # Allow cd to variable names
setopt AUTO_PUSHD       # Automatically push directories to stack
setopt PUSHD_IGNORE_DUPS # Don't push duplicates to stack

# Make completion case-insensitive and partial-word matching
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Created by `pipx` on 2025-09-04 13:24:14
export PATH="$PATH:/home/cady/.local/bin"

# Windows/WSL fallback: some shells lose the VS Code CLI even though the
# Windows install still exists. Keep this scoped as a fallback so Linux
# machines can still rely on their normal `code` binary.
if ! command -v code >/dev/null 2>&1; then
    code() {
        local vscode_cli="/mnt/c/Program Files/Microsoft VS Code/bin/code"

        if [ -x "$vscode_cli" ]; then
            "$vscode_cli" "$@"
        else
            print -u2 'zsh: command not found: code'
            return 127
        fi
    }
fi

export NVM_DIR="$HOME/.nvm"
load_nvm() {
    unset -f load_nvm nvm node npm npx corepack yarn pnpm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() { load_nvm; nvm "$@"; }
node() { load_nvm; node "$@"; }
npm() { load_nvm; npm "$@"; }
npx() { load_nvm; npx "$@"; }
corepack() { load_nvm; corepack "$@"; }
yarn() { load_nvm; yarn "$@"; }
pnpm() { load_nvm; pnpm "$@"; }

# direnv loads per-project environment variables, mainly for work/company
# projects where API keys and similar secrets should not live in the global
# shell environment.
eval "$(direnv hook zsh)"

# opencode
export PATH=/home/cady/.opencode/bin:$PATH

export PATH="$HOME/.local/bin:$PATH"
