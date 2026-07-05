# Claude Code Terminal Integration

## Purpose

Replace VSCode as the daily driver by giving Claude Code a terminal-native
workflow that covers the one thing VSCode's extension was providing that the
bare CLI doesn't: a side-by-side, multi-file diff review of changes Claude
proposes, before they're accepted.

Along the way, actually start using `lazygit` and `delta`, which are already
installed and configured in the dotfiles but currently unused day-to-day —
the cheat sheet should teach these, not just the new Claude Code pieces.

## What changes for the user, concretely

Today: `claude` runs in a plain terminal (in VSCode's integrated terminal or
any shell). Edits show up as text diffs in the transcript, approved/denied
with a keypress. This mode is not being replaced — it still works exactly the
same anywhere `claude` runs, including a bare terminal outside tmux/nvim.

After this build, there are three ways to invoke Claude Code, for three
different situations:

1. **Plain CLI, unchanged** — run `claude` directly in any shell. Same
   transcript-based diff approval as today. Use when nvim isn't involved at
   all (e.g. answering a question, working outside a repo).

2. **tmux popup (`prefix+c`)** — a floating `claude` over whatever pane
   you're in, for quick one-offs. Still plain CLI-mode diffs/approval inside
   the popup. Exits and vanishes when you quit Claude. Use for fast
   questions where you don't need to review file changes visually.

3. **Neovim-attached (`<leader>ac`), new** — only when you're editing in
   LazyVim. Claude Code runs as before, but claudecode.nvim intercepts each
   file edit and opens it as a native Neovim diff buffer (old vs. new)
   instead of a text diff in a transcript. If Claude touches multiple files
   in one turn, you get one diff buffer per file to step through
   (`<leader>an`/`<leader>ap`), accepting or rejecting each
   (`<leader>aa`/`<leader>ar`) — this is the part that replaces what VSCode's
   changed-files diff view was giving you.

Nothing forces mode 3. If you're mid-conversation in plain CLI mode (as in
this session), that experience is untouched — the new review flow only
kicks in when Claude Code is attached to a running Neovim instance.

## Components

### 1. `nvim/lua/plugins/claudecode.lua`

New LazyVim plugin spec adding [`coder/claudecode.nvim`](https://github.com/coder/claudecode.nvim).
It runs Claude Code as a companion process (via its MCP/WebSocket protocol)
and opens each file Claude touches as a native Neovim diff buffer, so changes
across multiple files can be reviewed and accepted/rejected like the VSCode
extension's changed-files view — without leaving Neovim.

Keymaps live under `<leader>a` (LazyVim's convention for AI-tool groupings,
mirroring `<leader>f` for find, `<leader>g` for git):

| Keymap | Action |
|---|---|
| `<leader>ac` | Toggle Claude Code chat/terminal split |
| `<leader>aa` | Accept current diff hunk/file |
| `<leader>ar` | Reject current diff hunk/file |
| `<leader>an` | Next diff hunk |
| `<leader>ap` | Previous diff hunk |

Exact keymap names/defaults will be finalized against the plugin's actual API
during implementation (the table above is the intended shape, not a
guarantee of the plugin's literal function names).

### 2. `tmux.conf`

Add a popup keybind so Claude Code can be summoned over any pane without
window/pane management:

```
bind-key c display-popup -E -d "#{pane_current_path}" "claude"
```

`prefix + c` opens a floating popup running `claude` in the current pane's
working directory; exiting Claude Code closes the popup automatically (`-E`).

### 3. `CHEATSHEET.md` (repo root)

A one-page reference covering:
- The tmux popup keybind and when to use it (quick one-off questions,
  no editor context needed)
- The nvim plugin keymaps and when to use them (working inside a file,
  want inline diff review)
- **What `lazygit` and `delta` actually are and how to use them**, since
  they're configured but unfamiliar:
  - `delta` is already your git pager (configured in `zshrc`), so plain
    `git diff` output is colorized/side-by-side through it — no new command
    to learn, just an explanation of why `git diff` looks the way it does.
  - `lazygit` (aliased `lg`) is a terminal UI for staging and committing:
    a file list you navigate with arrow keys, `space` to stage/unstage,
    a diff pane (rendered via delta) for the selected file, and `c` to
    commit. The cheat sheet will give a short "first five commands" primer
    (navigate, stage, view diff, commit, quit).
- The updated workflow loop: ask Claude something → it edits files → review
  diffs in Neovim (`claudecode.nvim`) → accept/reject → open `lazygit`
  (`lg`) to stage and commit, using its diff pane as a final pre-commit
  review

Not symlinked by `install.sh` — it's documentation, not a dotfile.

## Out of scope

- Changing the `lazygit`/`delta` configuration itself (both already work;
  this is purely about documenting/teaching the existing setup)
- Any VSCode-specific config removal (user can uninstall/stop using VSCode
  manually once comfortable)
- Automating Claude Code permission modes/settings — this is purely about
  invocation and diff-review ergonomics

## Testing / verification

- `lazy.nvim` sync succeeds and the plugin loads without error
- tmux popup opens with the new binding and runs `claude` in the right directory
- Manually walk through the cheat sheet's basic workflow loop once end-to-end
