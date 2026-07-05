# Claude Code Terminal Integration

## Purpose

Replace VSCode as the daily driver by giving Claude Code a terminal-native
workflow that covers the one thing VSCode's extension was providing that the
bare CLI doesn't: a side-by-side, multi-file diff review of changes Claude
proposes, before they're accepted.

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
- The basic workflow loop: ask Claude something → it edits files → review
  diffs in Neovim → accept/reject → commit via lazygit (existing tool,
  unchanged)

Not symlinked by `install.sh` — it's documentation, not a dotfile.

## Out of scope

- Changing how commits/git review work (lazygit + delta stay as-is)
- Any VSCode-specific config removal (user can uninstall/stop using VSCode
  manually once comfortable)
- Automating Claude Code permission modes/settings — this is purely about
  invocation and diff-review ergonomics

## Testing / verification

- `lazy.nvim` sync succeeds and the plugin loads without error
- tmux popup opens with the new binding and runs `claude` in the right directory
- Manually walk through the cheat sheet's basic workflow loop once end-to-end
