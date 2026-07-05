# Vim/Neovim Study Guide

A from-the-ground-up guide to the concepts that trip up new vim users —
modes, buffers, windows, and tabs — plus the core motions and the LazyVim
keymaps this setup gives you on top of them. Written for someone comfortable
in a normal text editor but new to modal editing.

See [README.md](../README.md) for the full keymap tables and
[tools.md](tools.md) for everything outside the editor.

## Table of contents

- [Modes: the big idea](#modes-the-big-idea)
- [Buffers vs. windows vs. tabs](#buffers-vs-windows-vs-tabs)
- [Core motions](#core-motions)
- [Editing](#editing)
- [Files: finding and browsing](#files-finding-and-browsing)
- [Search](#search)
- [Undo, redo, and the command line](#undo-redo-and-the-command-line)
- [LSP: code intelligence](#lsp-code-intelligence)
- [Putting it together: a typical session](#putting-it-together-a-typical-session)

---

## Modes: the big idea

Vim's one big departure from every other editor: your keyboard means
different things depending on *mode*. This is the #1 source of "why isn't
this key working" confusion (like `<Space>` typing a literal space instead
of triggering a leader keymap — that only happens in Insert mode).

| Mode | What keys do | How to get there |
|---|---|---|
| **Normal** | Keys are commands (`j` moves down, `dd` deletes a line) — nothing is typed as text | `Esc` from any other mode. This is the default/home mode. |
| **Insert** | Keys type text, like a normal editor | `i` (insert before cursor), `a` (after cursor), `o` (new line below) |
| **Visual** | Selects text to act on | `v` (character-wise), `V` (line-wise), `Ctrl+v` (block) |
| **Command** | Typing a `:` command (save, quit, search/replace) | `:` from Normal mode |

**The habit to build:** when in doubt, hit `Esc`. It always gets you back
to Normal mode, which is "home base" — almost every keymap in this guide
and in README.md is a Normal-mode keymap.

---

## Buffers vs. windows vs. tabs

This is the second-biggest source of confusion, because all three sound
like "a file is open." They're not the same thing:

- **Buffer** = a file loaded into memory. Every file you open becomes a
  buffer, whether or not it's currently visible on screen. Closing the
  window showing a buffer does *not* close the buffer — it's still loaded,
  just not displayed anywhere.
- **Window** = a viewport into a buffer. You can have multiple windows open
  at once (a split screen), each showing a different buffer, or even the
  *same* buffer twice (useful for viewing two parts of one file
  simultaneously).
- **Tab** = a collection of windows (a saved layout). Much less important
  here than in a browser — most people, and this setup, lean on buffers +
  windows and barely touch tabs. Skip tabs until the rest feels natural.

Concretely: if you open 5 files over a session, you have 5 buffers whether
you're looking at 1 window or split into 4. Switching buffers in the same
window is instant and lightweight (no split needed) — that's the main
workflow for moving between files.

**Buffers** (LazyVim defaults):

| Keys | Does |
|---|---|
| `<Space>fb` | Fuzzy-pick a buffer to switch to (Telescope) |
| `<Space>,` (or `<Space>bb`) | Same idea, quick buffer switcher |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<Space>bd` | Delete (close) current buffer |
| `:ls` | List all open buffers with numbers |
| `:b <number>` or `:b <partial-name>` | Jump to a specific buffer |

**Windows (splits):**

| Keys | Does |
|---|---|
| `<Space>-` (or `<Space>bs`) | Split window horizontally |
| `<Space>\|` | Split window vertically |
| `Ctrl+h/j/k/l` | Move focus between windows (also moves between tmux panes, seamlessly, via vim-tmux-navigator) |
| `<Space>ww` | Cycle to next window |
| `Ctrl+w` then `=` | Resize all windows to equal size |
| `:q` or `<Space>bd`-equivalent | Close current window |

**Tabs** (rarely needed, but for completeness):

| Keys | Does |
|---|---|
| `:tabnew` | Open a new tab |
| `gt` / `gT` | Next / previous tab |

---

## Core motions

These compose: a *count* + a *motion* (+ an *operator*, see [Editing](#editing)).

| Keys | Moves |
|---|---|
| `h` `j` `k` `l` | left / down / up / right (arrow keys also work, but these keep your hands on the home row) |
| `w` / `b` | forward / backward one word |
| `0` / `$` | start / end of line |
| `gg` / `G` | top / bottom of file |
| `{` / `}` | previous / next blank line (paragraph jump) |
| `5j` | down 5 lines (any motion can be prefixed with a count) |
| `%` | jump to matching bracket/paren |

`<Space>ff` opens a fuzzy file finder — the more common way to "go to"
somewhere new, versus scrolling with motions.

---

## Editing

Editing commands are usually **operator + motion**: the operator says
*what* to do, the motion says *how much*.

| Keys | Does |
|---|---|
| `x` | Delete character under cursor |
| `dd` | Delete (cut) current line |
| `dw` | Delete to end of word |
| `d$` | Delete to end of line |
| `yy` | Yank (copy) current line |
| `yw` | Yank to end of word |
| `p` / `P` | Paste after / before cursor |
| `cc` | Change (delete + enter Insert mode) current line |
| `cw` | Change to end of word |
| `u` | Undo |
| `Ctrl+r` | Redo |
| `.` | Repeat last change — extremely useful, get in the habit |
| `v` + motion + `d`/`y`/`c` | Visual-select a range, then act on it |
| `gcc` | Comment/uncomment current line |

`dd` then `p` is how you move a line; `yy` then `p` duplicates it.

---

## Files: finding and browsing

| Keys | Does |
|---|---|
| `<Space>ff` | Fuzzy-find a file by name (Telescope) |
| `<Space>fg` | Live grep — search file *contents* across the project (ripgrep-powered) |
| `<Space>e` | Toggle the file explorer sidebar (Neo-tree) |
| `<Space>fr` | Recently opened files |

Inside Neo-tree (`<Space>e`): `Enter` opens the file, `a` creates a new
file, `d` deletes, `r` renames — press `?` inside it for the full list.

---

## Search

| Keys | Does |
|---|---|
| `/pattern` | Search forward in the current buffer |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `<Space>fg` | Search across the whole project instead of just this buffer |
| `:%s/old/new/g` | Replace all `old` with `new` in the current buffer |
| `:%s/old/new/gc` | Same, but confirm each replacement |

---

## Undo, redo, and the command line

- `u` / `Ctrl+r` — undo / redo, as above. Vim's undo history survives even
  after you save.
- `:w` — write (save)
- `:q` — quit (fails if there are unsaved changes)
- `:wq` or `:x` — save and quit
- `:q!` — quit and discard unsaved changes
- `ZZ` (Normal mode, no colon) — save and quit, shorthand for `:wq<Enter>`

---

## LSP: code intelligence

Once a language server is attached (automatic for most languages LazyVim
supports), these work like an IDE's "go to" features:

| Keys | Does |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation for symbol under cursor |
| `<Space>ca` | Code actions (quick fixes, auto-imports) |
| `<Space>cr` | Rename symbol (renames every usage) |
| `<Space>cf` | Format current buffer |
| `]d` / `[d` | Next / previous diagnostic (error/warning) |

---

## Putting it together: a typical session

1. `<Space>ff` to find and open a file — becomes a buffer.
2. Edit with motions + operators (`dd`, `cw`, `.` to repeat), `Esc` to leave
   Insert mode when done typing.
3. `<Space>fg` to grep for something else you need to touch — opens as
   another buffer without losing your place in the first.
4. `<S-h>`/`<S-l>` or `<Space>fb` to flip between the buffers you have open,
   or `<Space>\|` to split and view two side by side.
5. `gd`/`K` to check a definition without leaving your flow.
6. `:w` to save, `<Space>gg` to open lazygit and commit (see README.md's
   Git and Claude Code sections).
