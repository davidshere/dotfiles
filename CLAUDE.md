# dotfiles

Personal dotfiles for macOS. Managed with symlinks via `install.sh`.

## Structure

| File | Symlinked to |
|------|-------------|
| `zshrc` | `~/.zshrc` |
| `tmux.conf` | `~/.tmux.conf` |
| `starship.toml` | `~/.config/starship.toml` |
| `nvim/` | `~/.config/nvim/` |

## Stack

- **Shell**: zsh + oh-my-zsh (theme disabled) + starship prompt
- **Prompt**: starship with TokyoNight colorscheme
- **Editor**: neovim with LazyVim distribution, TokyoNight theme
- **Multiplexer**: tmux with tokyo-night-tmux and vim-tmux-navigator
- **Key tools**: fzf, zoxide, bat, eza, lazygit, delta, ripgrep, fd

## Adding a new dotfile

1. Put the file in this repo
2. Add a `symlink` call to `install.sh`
3. Commit and push

## Bootstrap on a new machine

```bash
git clone git@github.com:davidshere/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
bash install.sh
```
