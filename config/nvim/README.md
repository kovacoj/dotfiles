# Neovim

This is a small Lua configuration, not a Neovim distribution. Start with
`init.lua`: it loads editor options, keymaps, and the plugin manager. Plugin
specifications live in `lua/plugins/` and are grouped by purpose.

Neovim 0.12 or newer and tree-sitter CLI 0.26.1 or newer are required. The
dotfiles installer installs the CLI through npm when it is missing. Run
`:checkhealth` after installation.

## First keys to learn

`<leader>` is Space. Pause after pressing Space to let which-key show the
available mappings.

| Key | Action |
| --- | --- |
| `-` | Open the parent directory with Oil |
| `Space e` | Open Oil in a floating window |
| `Space f f` | Find a file |
| `Space f g` | Search text in the project |
| `Space f b` | Switch buffers |
| `Space f z` | Jump to a zoxide directory |
| `/` (in buffer) | Fuzzy search current buffer |
| `Space g s` | Git status picker |
| `Space g c` | Git commits picker |
| `gd` / `gr` / `K` | Definition / references / documentation |
| `Space c r` | Rename a code symbol with the language server |
| `Space c a` | Show language-server code actions |
| `Space c f` | Format the current buffer |
| `[f` / `]f` | Previous / next function |
| `[c` / `]c` | Previous / next class |
| `[h` / `]h` | Previous / next changed Git hunk |
| `Space h p` | Preview the current hunk |
| `Space h s` | Stage the current hunk |

Oil treats a directory like an editable buffer: edit names or add/delete
lines, then write with `:w` to apply the filesystem changes. Press `g?` in Oil
to see all of its keys.

## Useful commands

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, update, or remove plugins |
| `:Mason` | Inspect installed language tools |
| `:checkhealth` | Diagnose Neovim and plugin integration |
| `:ConformInfo` | Diagnose formatting |
| `:Telescope help_tags` | Search Neovim documentation |
| `:Tutor` | Open Neovim's interactive fundamentals tutorial |

Use `:help something` whenever a concept or command is unfamiliar. Help is a
core part of the editor, not a fallback.
