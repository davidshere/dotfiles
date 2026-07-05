# Claude Code Terminal Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Give Claude Code a terminal-native workflow in this dotfiles repo — a tmux popup for quick invocation, a Neovim plugin for in-editor multi-file diff review, and a cheat sheet documenting the whole flow (including `lazygit`/`delta`, which are configured but not yet part of the user's habits).

**Architecture:** Three independent, additive config changes in the existing dotfiles repo: a new LazyVim plugin spec file, one new tmux keybind, and one new documentation file. No existing behavior is removed or renamed.

**Tech Stack:** tmux, Neovim (LazyVim), `coder/claudecode.nvim` (depends on `folke/snacks.nvim`, already present via LazyVim), `lazygit`, `git-delta` — all already installed per `install.sh`.

## Global Constraints

- Do not rebind `prefix+c` (tmux default: new-window) — the user relies on it. Use `prefix+a` for the Claude popup instead.
- `coder/claudecode.nvim` keymaps must match the plugin's actual documented commands: `<leader>ac` (toggle), `<leader>af` (focus), `<leader>ab` (add buffer), `<leader>as` (send selection, visual mode), `<leader>aa` (accept diff / same as `:w`), `<leader>ad` (reject diff / same as `:q`). Do not invent hunk-navigation keymaps — the plugin has none.
- `CHEATSHEET.md` is documentation only — do not add it to `install.sh`'s `symlink` calls.
- Spec reference: `docs/superpowers/specs/2026-07-04-claude-code-terminal-integration-design.md`.

---

### Task 1: Add claudecode.nvim plugin spec

**Files:**
- Create: `nvim/lua/plugins/claudecode.lua`

**Interfaces:**
- Produces: the `:ClaudeCode` family of Ex commands and `<leader>a*` keymaps, used manually by the user (no other task depends on this programmatically).

- [ ] **Step 1: Create the plugin spec file**

```lua
-- nvim/lua/plugins/claudecode.lua
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}
```

- [ ] **Step 2: Verify the plugin installs and loads**

Run: `nvim --headless "+Lazy! sync" +qa`
Expected: command exits with status 0 and no error output mentioning `claudecode.nvim` or `snacks.nvim`.

Then run: `nvim --headless -c "lua print(vim.inspect(require('lazy.core.config').plugins['claudecode.nvim'] ~= nil))" -c "qa"`
Expected: prints `true`.

- [ ] **Step 3: Verify the keymap is registered**

Run: `nvim --headless -c "lua vim.cmd('redir @a') ; vim.cmd('verbose map <leader>ac') ; vim.cmd('redir END') ; print(vim.fn.getreg('a'))" -c "qa" 2>&1 | grep -i claudecode`
Expected: output includes a line referencing `ClaudeCode` (confirms the `<leader>ac` mapping is registered, even though the command only fully loads on first invocation per the `cmd` lazy-load list).

- [ ] **Step 4: Commit**

```bash
git add nvim/lua/plugins/claudecode.lua
git commit -m "Add claudecode.nvim for in-editor Claude Code diff review"
```

---

### Task 2: Add tmux popup keybind

**Files:**
- Modify: `tmux.conf:31-33` (insert after the pane-resize bindings, before the `# Plugins` section)

**Interfaces:**
- Produces: `prefix+a` tmux keybind, used manually by the user (no other task depends on it).

- [ ] **Step 1: Add the binding**

Edit `tmux.conf`, inserting this block after the `bind -r L resize-pane -R 5` line and before `# Plugins`:

```
# Claude Code popup
bind-key a display-popup -E -d "#{pane_current_path}" "claude"
```

Resulting file section (lines 27-34):

```
# Resize panes with vim keys (repeatable)
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Claude Code popup
bind-key a display-popup -E -d "#{pane_current_path}" "claude"

# Plugins
```

- [ ] **Step 2: Verify the config is syntactically valid**

Run: `tmux -f tmux.conf -L claudecode-test start-server \; source-file tmux.conf \; kill-server`
Expected: exits with status 0 and no "bad command" or parse errors printed.

- [ ] **Step 3: Verify the binding is registered**

Run: `tmux -f tmux.conf -L claudecode-test start-server \; source-file tmux.conf \; list-keys | grep 'bind-key.*-a ' ; tmux -L claudecode-test kill-server`
Expected: a line showing `a` bound to `display-popup ... "claude"`.

- [ ] **Step 4: Commit**

```bash
git add tmux.conf
git commit -m "Add tmux popup keybind (prefix+a) for Claude Code"
```

---

### Task 3: Write CHEATSHEET.md

**Files:**
- Create: `CHEATSHEET.md`

**Interfaces:**
- Consumes: keymaps from Task 1 (`<leader>ac`, `<leader>af`, `<leader>ab`, `<leader>as`, `<leader>aa`, `<leader>ad`) and the tmux binding from Task 2 (`prefix+a`). Must reference these exactly as implemented, not as originally drafted in the spec.
- Produces: nothing consumed programmatically — this is the terminal deliverable for the user.

- [ ] **Step 1: Write the cheat sheet**

```markdown
# Claude Code Terminal Cheat Sheet

Three ways to use Claude Code from the terminal, plus the git tools that
round out the review/commit loop.

## 1. Plain CLI

Run `claude` in any shell. Works exactly as it always has — edits show up
as text diffs in the transcript, approved/denied with a keypress. Use this
when you're not inside tmux/nvim, or just want to ask a question.

## 2. tmux popup — `prefix + a`

Opens a floating `claude` over whatever pane you're in, running in that
pane's current directory. Closes automatically when you exit Claude. Use
for quick one-offs where you don't need to review file changes visually.

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

Ask Claude something (CLI, popup, or nvim) → it edits files → review the
diffs (transcript, or Neovim diff buffers if using claudecode.nvim) → open
`lg` to stage and commit, using its diff pane as a final pre-commit check.
```

- [ ] **Step 2: Verify it's not wired into install.sh**

Run: `grep -n CHEATSHEET install.sh`
Expected: no output (exit status 1) — confirms it's intentionally not symlinked.

- [ ] **Step 3: Commit**

```bash
git add CHEATSHEET.md
git commit -m "Add cheat sheet for Claude Code terminal workflow and lazygit/delta"
```

---

### Task 4: End-to-end manual walkthrough

**Files:** none (verification only)

**Interfaces:** none — this task exercises Tasks 1-3 together.

- [ ] **Step 1: Reload tmux config in a real session**

Run (inside an actual tmux session, not the test socket from Task 2): `tmux source-file ~/.tmux.conf` (assumes `install.sh` has been re-run or `tmux.conf` is already symlinked to `~/.tmux.conf`, per existing repo setup)
Expected: `Reloaded!` message is not shown (that's bound to `prefix+r`, a manual step) — just confirm no error is printed.

- [ ] **Step 2: Manually trigger the popup**

Press `prefix + a`.
Expected: a floating popup opens running `claude` in the current pane's directory. Exit Claude (`/exit` or Ctrl-D); popup closes automatically.

- [ ] **Step 3: Manually trigger the nvim integration**

Open Neovim on any file in this repo, press `<leader>ac`.
Expected: a Claude Code terminal split opens. Ask it to make a trivial edit to a scratch file; confirm the edit opens as a native diff buffer, and that `<leader>aa` accepts it (file is saved) or `<leader>ad` rejects it (file unchanged).

- [ ] **Step 4: Manually walk the lazygit step**

With an uncommitted change present, run `lg`.
Expected: file list shows the change; `space` stages it, right panel shows a delta-rendered diff, `c` + `enter` commits it, `q` exits.

- [ ] **Step 5: Report back**

No commit for this task — it's verification only. If any step fails, fix the relevant Task 1-3 file and re-run that task's verification steps before retrying here.
