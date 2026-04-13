# Path
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.docker/bin

# macOS extras
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
fi

# Go
export PATH=$PATH:/usr/local/go/bin

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""  # Disabled in favor of starship

plugins=(
  git
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# zsh plugins (path differs by OS)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fzf
command -v fzf >/dev/null && eval "$(fzf --zsh)"

# zoxide (smarter cd)
if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv >/dev/null || [ -d "$PYENV_ROOT" ]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# rbenv
command -v rbenv >/dev/null && eval "$(rbenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# Editor
export EDITOR="nvim"
alias vim="nvim"
alias python="python3"

# bat (cat replacement)
alias cat="bat"
alias less="bat --paging=always"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# eza (ls replacement)
alias ls="eza --icons"
alias ll="eza --icons -la --git"
alias tree="eza --tree --icons"

# git
alias lg="lazygit"

# Personal
alias wakepc='wakeonlan -i 192.168.7.255 2C:F0:5D:2D:4B:37'
export PREFECT_API_URL=http://192.168.7.214:4200/api

# Starship prompt (must be last)
eval "$(starship init zsh)"
