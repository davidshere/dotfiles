# Path
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.docker/bin
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

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
eval "$(fzf --zsh)"

# zoxide (smarter cd)
eval "$(zoxide init zsh)"
alias cd="z"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# rbenv
eval "$(rbenv init -)"

# Editor
export EDITOR="nvim"
alias vim="nvim"

# bat (cat replacement) with TokyoNight
export BAT_THEME="tokyonight_night"
alias cat="bat"

# eza (ls replacement)
alias ls="eza --icons"
alias ll="eza --icons -la --git"
alias tree="eza --tree --icons"

# git
alias lg="lazygit"
git config --global core.pager delta
git config --global delta.navigate true
git config --global delta.dark true
git config --global delta.syntax-theme "tokyonight_night"
git config --global interactive.diffFilter "delta --color-only"

# Personal
alias wakepc='wakeonlan -i 192.168.7.255 2C:F0:5D:2D:4B:37'
export PREFECT_API_URL=http://192.168.7.214:4200/api

# Starship prompt (must be last)
eval "$(starship init zsh)"
