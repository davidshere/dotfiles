#!/usr/bin/env bash
set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "==> Installing brew packages..."
brew install fzf zoxide bat eza lazygit git-delta fd ripgrep \
  zsh-autosuggestions zsh-syntax-highlighting starship

echo "==> Symlinking configs..."

symlink() {
  local src="$DOTFILES/$1"
  local dst="$2"
  local dir
  dir="$(dirname "$dst")"

  mkdir -p "$dir"

  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "  Backing up $dst -> $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$src" "$dst"
  echo "  $dst -> $src"
}

symlink zshrc         ~/.zshrc
symlink tmux.conf     ~/.tmux.conf
symlink starship.toml ~/.config/starship.toml
symlink nvim          ~/.config/nvim

echo "==> Installing tmux plugins..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
~/.tmux/plugins/tpm/bin/install_plugins

echo ""
echo "Done. Open a new shell to apply zsh changes."
echo "In tmux, press prefix + I to install new plugins."
