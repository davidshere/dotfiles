# dotfiles

Personal macOS/Ubuntu developer environment. Managed with symlinks via `install.sh`.

## Bootstrap

```bash
git clone git@github.com:davidshere/dotfiles.git ~/src/dotfiles
cd ~/src/dotfiles
bash install.sh
```

Works on macOS (via Homebrew) and Ubuntu (via apt + GitHub releases). No Linuxbrew required.

---

## Shell (zsh)

- **Autocomplete** — start typing a command, press `→` to accept the suggestion
- **Syntax highlighting** — commands turn green when valid, red when not
- **Smarter `cd`** — `cd` is aliased to `zoxide`: type a partial directory name you've visited before and it jumps there (e.g. `cd dot` → `~/src/dotfiles`)
- **Fuzzy search** — `Ctrl+R` fuzzy-searches your command history; `Ctrl+T` fuzzy-finds files

### Aliases

| Alias | Does |
|-------|------|
| `ls` | `eza` with icons |
| `ll` | `eza` with icons, long format, git status |
| `tree` | directory tree with icons |
| `cat` | `bat` — syntax-highlighted file viewer with line numbers |
| `vim` | neovim |
| `lg` | lazygit |
| `cd` | zoxide (smart jump) |

---

## Prompt (starship)

- OS icon ( macOS /  Linux) — tells you which machine you're on at a glance
- Current directory (truncated to 3 levels)
- Git branch + status (dirty, ahead/behind, etc.)
- Current time

---

## Editor (neovim + LazyVim)

Full-featured IDE-like setup out of the box via [LazyVim](https://lazyvim.org).

**Key bindings** (prefix: `<Space>`)

| Keys | Does |
|------|------|
| `<Space>ff` | Find file (fuzzy) |
| `<Space>fg` | Live grep across project |
| `<Space>fb` | Switch buffer |
| `<Space>e` | Toggle file explorer |
| `<Space>gg` | Open lazygit inside nvim |
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<Space>ca` | Code actions |
| `<Space>cr` | Rename symbol |

Git diffs in the gutter, LSP diagnostics inline, and TokyoNight theme throughout.

---

## Multiplexer (tmux)

Mouse support on. Windows and panes numbered from 1.

**Key bindings** (prefix: `Ctrl+B`)

| Keys | Does |
|------|------|
| `prefix + \|` | Split pane horizontally (opens in current dir) |
| `prefix + -` | Split pane vertically (opens in current dir) |
| `prefix + r` | Reload tmux config |
| `prefix + H/J/K/L` | Resize pane (repeatable) |
| `Ctrl+H/J/K/L` | Navigate between tmux panes **and** nvim splits seamlessly |

---

## Git

- **`lg`** — lazygit: full TUI for staging, committing, rebasing, diffing
- **`delta`** — syntax-highlighted diffs in `git diff` / `git log -p`
- **`gh`** — GitHub CLI for PRs, issues, and releases from the terminal

---

## Theme

Everything uses **TokyoNight Night** — neovim, tmux status bar, bat, delta, and the starship prompt all share the same palette.
