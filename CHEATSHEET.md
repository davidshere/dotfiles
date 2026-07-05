# Claude Code Terminal Cheat Sheet

Three ways to use Claude Code from the terminal, plus the git tools that
round out the review/commit loop.

## 1. Plain CLI

Run `claude` in any shell. Works exactly as it always has — edits show up
as text diffs in the transcript, approved/denied with a keypress. Use this
when you're not inside tmux/nvim, or just want to ask a question.

## 2. tmux window — `prefix + a`

Switches to a dedicated `claude` window (creating it the first time, in
your current pane's directory). Claude keeps running in the background
when you switch away — `prefix + a` again, or any normal window switch
(`prefix + p`/`prefix + n`, or a window number), returns to it without
losing the session. Use this for an ongoing terminal chat alongside your
editor, with no file/diff awareness (that's Neovim, below).

## 3. Neovim-attached (claudecode.nvim)

Only active inside LazyVim. Claude's file edits open as native Neovim diff
buffers (old vs. new) instead of terminal text — the multi-file review
VSCode gave you.

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

## Git: lazygit and delta

Both are already installed and configured (`zshrc`) but easy to have missed:

- **delta** is your git pager — plain `git diff` is already going through
  it, which is why diffs are colorized/readable without you doing anything
  extra.
- **lazygit** (aliased `lg`) is a terminal UI for staging and committing.
  Run `lg` in any repo. First five things to know:
  1. Arrow keys / `j`/`k` move between files in the top-left panel.
  2. `space` stages/unstages the selected file.
  3. The right-hand panel shows the diff for the selected file (rendered
     via delta).
  4. `c` opens a commit message prompt; `enter` confirms the commit.
  5. `q` quits back to the shell.

## Putting it together

Ask Claude something (CLI, tmux window, or nvim) → it edits files → review
the diffs (transcript, or Neovim diff buffers if using claudecode.nvim) →
open `lg` to stage and commit, using its diff pane as a final pre-commit
check.
