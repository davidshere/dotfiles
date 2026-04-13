#!/usr/bin/env bash
set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# ── Helpers ────────────────────────────────────────────────────────────────────

gh_latest() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])"
}

gh_deb() {
  local repo="$1" pattern="$2"
  local tag; tag="$(gh_latest "$repo")"
  local ver="${tag#v}"
  local url="https://github.com/$repo/releases/download/$tag/$(eval echo "$pattern")"
  echo "  installing $repo from $url"
  curl -fsSL "$url" -o /tmp/pkg.deb
  sudo dpkg -i /tmp/pkg.deb
  rm /tmp/pkg.deb
}

# ── Package installation ───────────────────────────────────────────────────────

install_macos() {
  echo "==> Installing brew packages..."
  brew install fzf zoxide bat eza lazygit git-delta fd ripgrep \
    zsh-autosuggestions zsh-syntax-highlighting starship gh
}

install_linux() {
  echo "==> Installing apt packages..."
  sudo apt-get update -qq
  sudo apt-get install -y \
    zsh fzf ripgrep fd-find \
    zsh-autosuggestions zsh-syntax-highlighting

  # fd-find installs as fdfind; symlink to fd if not already present
  if ! command -v fd &>/dev/null; then
    sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
  fi

  echo "==> Installing gh (GitHub CLI)..."
  if ! command -v gh &>/dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update -qq && sudo apt-get install -y gh
  fi

  echo "==> Installing bat..."
  gh_deb "sharkdp/bat" "bat_\${ver}_amd64.deb"

  echo "==> Installing git-delta..."
  gh_deb "dandavison/delta" "git-delta_\${ver}_amd64.deb"

  echo "==> Installing eza..."
  local eza_tag; eza_tag="$(gh_latest eza-community/eza)"
  curl -fsSL "https://github.com/eza-community/eza/releases/download/$eza_tag/eza_x86_64-unknown-linux-gnu.tar.gz" \
    | sudo tar -xz -C /usr/local/bin eza

  echo "==> Installing lazygit..."
  local tag; tag="$(gh_latest jesseduffield/lazygit)"
  local ver="${tag#v}"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/$tag/lazygit_${ver}_Linux_x86_64.tar.gz" \
    | sudo tar -xz -C /usr/local/bin lazygit

  echo "==> Installing zoxide..."
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

  echo "==> Installing starship..."
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes

  echo "==> Setting default shell to zsh..."
  if [ "$(basename "$SHELL")" != "zsh" ]; then
    chsh -s "$(which zsh)"
    echo "  Default shell changed to zsh. Log out and back in for it to take effect."
  fi
}

# ── Detect OS and install ──────────────────────────────────────────────────────

case "$(uname -s)" in
  Darwin) install_macos ;;
  Linux)  install_linux ;;
  *)      echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

# ── Symlinks ───────────────────────────────────────────────────────────────────

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

# ── tmux plugins ──────────────────────────────────────────────────────────────

echo "==> Installing tmux plugins..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
~/.tmux/plugins/tpm/bin/install_plugins

echo ""
echo "Done. Open a new shell to apply zsh changes."
echo "In tmux, press prefix + I to install new plugins."
