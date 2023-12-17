# Add alias for lsd.
# https://github.com/lsd-rs/lsd
# brew install lsd
alias k="lsd"
alias kk="lsd -l"
alias ko="lsd -l --permission=octal"

# Aliases for git.
alias gs="git status"
alias gp="git pull && git push"
alias gc="git commit"
alias ga="git add"

# Aliases for z.
# https://github.com/rupa/z
# brew install z
alias j=z

# Use GPG agent on tty.
GPG_TTY=$(tty)
export GPG_TTY

# Start tmux with zsh.
# https://github.com/tmux/tmux
# brew install tmux
if [[ "$(uname -s)" == "Darwin" ]]; then
    # Only start tmux if using macOS (host) and not already in tmux session.
    if [ -t 0 ] && [[ -z $TMUX ]] && [[ $- = *i* ]]; then exec tmux; fi
fi

# Extemd FPATH, the search path for function definitions, with zsh-completions.
# https://github.com/zsh-users/zsh-completions
# brew install zsh-completions
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

# Load ZSH completion system.
autoload -Uz compinit; compinit

# Improve completion menu style.
zstyle ':completion:*' menu select

# Load z completion plugin.
# https://github.com/rupa/z
# brew install z
source "$(brew --prefix)/etc/profile.d/z.sh"

# Load autosuggestions.
# https://github.com/zsh-users/zsh-autosuggestions
# brew install zsh-autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_STRATEGY

# Load syntax highlighting.
# https://github.com/zsh-users/zsh-syntax-highlighting
# brew install zsh-syntax-highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR

# Load Starship prompt.
# https://github.com/starship/starship
# brew install starship
eval "$(starship init zsh)"

# Load Atuin.
# https://github.com/atuinsh/atuin
# brew install atuin
eval "$(atuin init zsh)"

# Load pyenv
# https://github.com/pyenv
# brew install pyenv
if command -v pyenv &> /dev/null; then
    # Make sure pyenv is installed before loading.
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# Extend colorization of list output.
# https://github.com/trapd00r/LS_COLORS
source ~/.config/lscolors.sh

# Load custom highlighting styles.
source ~/.config/syntax.sh

