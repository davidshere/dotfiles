# Tools Reference

Deep, example-driven reference for every tool this repo installs and
configures. Start with [README.md](../README.md) for the high-level tour —
this doc fills in the "how do I actually use this" gaps for everything else.

## Table of contents

- [Shell: zsh](#shell-zsh)
- [fzf — fuzzy finder](#fzf--fuzzy-finder)
- [eza — ls replacement](#eza--ls-replacement)
- [bat — cat replacement](#bat--cat-replacement)
- [ripgrep (rg) — fast search](#ripgrep-rg--fast-search)
- [fd — fast find](#fd--fast-find)
- [glow — markdown viewer](#glow--markdown-viewer)
- [lazygit](#lazygit)
- [delta — git diff pager](#delta--git-diff-pager)
- [gh — GitHub CLI](#gh--github-cli)
- [starship — prompt](#starship--prompt)
- [tmux](#tmux)
- [Neovim / LazyVim](#neovim--lazyvim)

---

## Shell: zsh

Configured in `zshrc`, oh-my-zsh with the theme disabled (starship replaces
it) and two plugins:

- `git` — adds git aliases like `gst`, `gco`, `gp` (see oh-my-zsh git plugin
  docs; run `alias | grep '^g'` to see what's active).
- `colored-man-pages` — man pages get syntax highlighting.

Plus two standalone plugins sourced directly (not via oh-my-zsh):

- **zsh-autosuggestions** — as you type, a greyed-out suggestion appears
  based on history. Press `→` (or `End`) to accept it, or keep typing to
  ignore it.
- **zsh-syntax-highlighting** — commands turn green if they resolve to a
  valid executable/alias/function, red if not, *before* you hit enter.

`~/.zshrc.local` is sourced last (before starship) if it exists — use it for
machine-specific env vars, secrets, or aliases you don't want committed.

---

## fzf — fuzzy finder

Loaded via `eval "$(fzf --zsh)"` (or sourced scripts on older apt installs).
Default keybindings:

| Keys | Does |
|---|---|
| `Ctrl+R` | Fuzzy-search shell history. Type to filter, `↑`/`↓` to move, `Enter` to run, `Ctrl+C`/`Esc` to cancel. |
| `Ctrl+T` | Fuzzy-find a file/directory under the cwd and insert its path at the cursor. |
| `Alt+C` | Fuzzy-find a directory and `cd` into it. |
| `**<Tab>` | Trigger completion, e.g. `vim **<Tab>` fuzzy-finds a file to open. |

fzf also shows up inside lazygit and many nvim pickers.

---

## eza — ls replacement

Aliased as `ls`, `ll`, `tree`:

```bash
ls          # eza --icons: file-type icons, same layout as plain ls
ll          # eza --icons -la --git: long format, hidden files, git status column
tree        # eza --tree --icons: recursive tree view
```

The `--git` flag in `ll` adds a column showing per-file git status (modified,
new, staged) without running `git status` separately. Useful flags not
aliased, run directly with `eza`:

```bash
eza -la --git --sort=modified   # newest-changed files first
eza --tree --level=2            # tree, limited to 2 levels deep
```

---

## bat — cat replacement

Aliased as `cat` and `less`, and wired in as `$MANPAGER` so `man <cmd>` gets
syntax highlighting too.

```bash
cat script.py          # syntax-highlighted, with line numbers
cat -A file.txt         # show non-printing characters (tabs, line endings)
cat -p file.txt         # "plain" mode: no line numbers/decorations, for piping
bat --diff file.txt     # git-aware: highlights lines changed since last commit
```

Since `cat` is aliased, use `\cat` or `command cat` if you need the real
coreutils `cat` for scripting (e.g. no ANSI codes in piped output).

---

## ripgrep (rg) — fast search

Not aliased — invoke directly as `rg`. Respects `.gitignore` by default, so
it never wastes time on `node_modules` or `.git`.

```bash
rg "TODO"                     # recursive search from cwd
rg -i "todo"                  # case-insensitive
rg "TODO" --type py           # limit to Python files
rg -l "TODO"                  # just filenames, no matched lines
rg -A3 -B1 "def foo"           # 3 lines after, 1 line before each match
rg --no-ignore "secret"       # include gitignored files too
rg -g '!*.test.js' "useState" # exclude a glob pattern
```

This is the same engine behind Neovim's live grep (`<Space>fg`).

---

## fd — fast find

A friendlier `find`. On Linux it installs as `fdfind` and `install.sh`
symlinks it to `fd`.

```bash
fd config              # find files/dirs matching "config" under cwd
fd -e lua               # find by extension
fd -H config            # include hidden files (fd excludes them by default)
fd -t d node_modules    # only match directories
fd -x rm {}             # execute a command per match
```

Like ripgrep, it respects `.gitignore` unless you pass `-I`/`--no-ignore`.

---

## glow — markdown viewer

```bash
mdview README.md   # wraps `glow -p README.md`: paginated, rendered markdown
glow               # with no args, browse markdown files in cwd interactively
glow https://raw.githubusercontent.com/...  # render a remote markdown URL
```

`mdview` is a zshrc function, not a raw alias, so it can print a status line
before handing off to glow.

---

## lazygit

Aliased `lg`. Terminal UI for git, also reachable from inside Neovim via
`<Space>gg`.

| Key | Does |
|---|---|
| `j`/`k` or arrows | Move within a panel |
| `h`/`l` or arrows | Move between panels |
| `space` | Stage/unstage the selected file (or hunk, in the diff view) |
| `a` | Stage/unstage *all* files |
| `enter` | Stage individual hunks/lines (drill into a file) |
| `c` | Open commit message prompt |
| `C` | Commit, opening `$EDITOR` for the message |
| `P` | Push |
| `p` | Pull |
| `b` | Branches panel |
| `s` | Stash |
| `d` | Discard changes to selected file (careful — destructive) |
| `x` | Show more keybindings for the focused panel |
| `q` | Quit |

The diff panel renders through delta, so hunk coloring matches what you see
in plain `git diff`.

---

## delta — git diff pager

Configured as git's pager (see global `.gitconfig`, not this repo), so
`git diff`, `git show`, `git log -p`, and `git blame` are colorized and
side-by-side-capable automatically — no extra flags needed. Nothing to
invoke directly; it activates transparently whenever git needs a pager.

---

## gh — GitHub CLI

```bash
gh pr create              # open a PR from the current branch, interactive prompts
gh pr list                # list open PRs in the repo
gh pr view 123 --web      # open PR #123 in the browser
gh pr checkout 123        # check out someone else's PR locally
gh issue list             # list open issues
gh repo clone owner/repo  # clone without a full git URL
gh auth status            # check login state
```

First-time setup: `gh auth login` (interactive, walks through browser or
token auth).

---

## starship — prompt

Config in `starship.toml`. Shows, left to right: OS icon, current directory
(truncated to 3 levels), git branch + status, then time on the right.
Git status symbols to know:

| Symbol | Meaning |
|---|---|
| `!` | Modified files |
| `?` | Untracked files |
| `+` | Staged files |
| `⇡`/`⇣` | Ahead/behind upstream |

No keybindings — it's read-only. Edit `starship.toml` and open a new shell
(or `exec zsh`) to see changes.

---

## tmux

Prefix is `Ctrl+B`. Config in `tmux.conf`. Beyond what's in the README:

| Keys | Does |
|---|---|
| `prefix + c` | New window |
| `prefix + ,` | Rename current window |
| `prefix + n` / `prefix + p` | Next / previous window |
| `prefix + <number>` | Jump to window by number |
| `prefix + z` | Zoom current pane (toggle fullscreen within the tmux window) |
| `prefix + x` | Kill current pane |
| `prefix + d` | Detach from session |
| `prefix + I` | Install/update tmux plugins (via tpm) |
| `Ctrl+H/J/K/L` | Move between tmux panes *and* nvim splits seamlessly (vim-tmux-navigator) |

Sessions persist detached — `tmux attach` (or `tmux a`) reattaches to the
last session; `tmux ls` lists all running sessions. See the
[Claude Code section](../README.md#claude-code) in the README for how this
pattern is used for the Claude Code popup specifically.

Plugins (managed by tpm, installed to `~/.tmux/plugins/`):

- `tokyo-night-tmux` — status bar theme matching nvim/starship/bat/delta.
- `vim-tmux-navigator` — the `Ctrl+H/J/K/L` pane/split navigation above.

---

## Neovim / LazyVim

Full LazyVim distribution, TokyoNight theme. README.md covers the core
keymaps (`<Space>ff`, `<Space>fg`, LSP bindings, etc.) and the
[Claude Code section](../README.md#claude-code) covers the claudecode.nvim
integration. A few more worth knowing:

| Keys | Does |
|---|---|
| `<Space>l` | Open Lazy.nvim plugin manager (install/update/health-check plugins) |
| `<Space>cf` | Format current buffer |
| `<Space>xx` | Toggle diagnostics list (Trouble) |
| `]d` / `[d` | Jump to next/previous diagnostic |
| `gcc` | Comment/uncomment current line |
| `<Space>uf` | Toggle autoformat-on-save |

Plugin config lives under `nvim/lua/plugins/`; `:Lazy` is the plugin
manager UI, `:LazyHealth` / `:checkhealth` diagnose broken installs.
