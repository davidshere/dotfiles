# Path
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH:$HOME/.docker/bin

# macOS extras
if [[ "$(uname)" == "Darwin" ]]; then
  export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"
fi

# Go
export PATH=$PATH:/usr/local/go/bin

# Completions (pick up Homebrew's completion functions on macOS)
if [ -d /opt/homebrew/share/zsh/site-functions ]; then
  FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit && compinit

# zsh plugins (path differs by OS)
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# fzf (--zsh flag requires 0.48+; fall back to sourcing scripts for older apt installs)
if command -v fzf >/dev/null; then
  if fzf --zsh &>/dev/null; then
    eval "$(fzf --zsh)"
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

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

# glow (markdown renderer) - `mdview file.md` to preview rendered markdown
# Force the dark style: inside tmux glow's terminal-background detection fails
# and it falls back to the light style (dark text -> invisible on a dark bg).
mdview() {
  echo "Rendering $1 with glow..." >&2
  glow -s dark -p "$@"
}

# eza (ls replacement)
alias ls="eza --icons=auto"
alias ll="eza --icons=auto -la --git"
alias tree="eza --tree --icons=auto"

# git
alias lg="lazygit"

# Local overrides (machine-specific config, not committed)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Starship prompt (must be last)
eval "$(starship init zsh)"


. "$HOME/.local/bin/env"
