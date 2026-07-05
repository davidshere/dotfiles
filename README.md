# dotfiles

Personal macOS/Ubuntu developer environment. Managed with symlinks via `install.sh`.

For deeper, example-driven usage of every tool below, see
[docs/tools.md](docs/tools.md).

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

## Claude Code

Three ways to use Claude Code from the terminal:

### 1. Plain CLI

Run `claude` in any shell. Works exactly as it always has — edits show up
as text diffs in the transcript, approved/denied with a keypress. Use this
when you're not inside tmux/nvim, or just want to ask a question.

### 2. tmux popup — `prefix + a`

Opens a floating `claude`, backed by a detached tmux session (`claude`) so
it survives closing the popup:

- **Leave without killing Claude:** press `prefix + d` inside the popup —
  this detaches the inner session (not your whole tmux client), the popup
  closes, and Claude keeps running in the background.
- **Come back:** `prefix + a` again reattaches to the same session instead
  of starting a fresh one.
- **Actually quit:** `/exit` or Ctrl-D inside Claude ends the session for
  good; the next `prefix + a` starts a new one.

No file/diff awareness here — that's Neovim, below.

### 3. Neovim-attached (claudecode.nvim)

Claude's file edits open as native Neovim diff buffers (old vs. new)
instead of terminal text — the multi-file review VSCode gave you.

| Keymap | Action |
|---|---|
| `<leader>ac` | Toggle the Claude Code terminal split |
| `<leader>af` | Focus the Claude Code terminal |
| `<leader>ab` | Add the current buffer to Claude's context |
| `<leader>as` (visual mode) | Send the selected text to Claude |
| `<leader>aa` | Accept the current diff (same as `:w`) |
| `<leader>ad` | Reject the current diff (same as `:q`) |

Workflow: open the file(s) you're working on, `<leader>ac` to start
chatting, let Claude edit, review each file's diff buffer, `<leader>aa`/`:w`
or `<leader>ad`/`:q` per file.

**Putting it together:** ask Claude something (CLI, popup, or nvim) → it
edits files → review the diffs (transcript, or Neovim diff buffers if using
claudecode.nvim) → open `lg` to stage and commit, using its diff pane as a
final pre-commit check.

---

## Theme

Everything uses **TokyoNight Night** — neovim, tmux status bar, bat, delta, and the starship prompt all share the same palette.
