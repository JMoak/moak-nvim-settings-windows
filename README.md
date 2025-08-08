# Neovim Config (Windows) — lazy.nvim-based

This repo contains only my Neovim **config**. Plugins are managed by **lazy.nvim** and install into the Neovim data dir on first run.

## What’s here
- `init.lua` — all core options, keymaps, and bootstrap
- `lua/plugins/` — plugin spec files loaded by `require("lazy").setup("plugins")`

## Windows paths
- **Config:** `%LOCALAPPDATA%\nvim`
- **Data (plugins, etc.):** `%LOCALAPPDATA%\nvim-data`

## Quick install (fresh machine)

1. Backup any existing config:
   ```powershell
   if (Test-Path $env:LOCALAPPDATA\nvim) { Rename-Item $env:LOCALAPPDATA\nvim nvim.bak }
   ```

2. Clone this repo into your Neovim config path:
   ```powershell
   git clone https://github.com/<you>/<repo> $env:LOCALAPPDATA\nvim
   ```

3. Start Neovim:
   - On first run, **lazy.nvim** bootstraps automatically and begins installing plugins.
   - If it doesn’t, run `:Lazy sync`.

> That’s it. Nothing else to install for the core config.

## Custom commands provided

- `:ClaudeCode`  
  Opens netrw **Vexplore** on the left, then a right vertical split running a terminal with `claude`, and focuses the terminal in insert mode.  
  **Requires:**  
  - Built-in **netrw** (enabled by default; don’t disable it)  
  - `claude` CLI available in your `PATH` (or change the command in `init.lua`)

- `:EditLeft [file]`  
  - With no args: opens **Vexplore** (netrw) in a left split.  
  - With a filename: opens that file in a left split.  
  **Requires:** netrw enabled.

## Kickstart as the base
This config takes inspiration from `kickstart.nvim` (not a full distro) and brings over its best, minimal pieces:

- **lazy.nvim**: Plugin manager with fast startup and lazy-loading.
- **nvim-treesitter**: Modern syntax highlighting and better code structure.
- **LSP + mason + lspconfig**: Language servers with easy install/updates.
- **fidget.nvim**: Small status for LSP progress/initialization.
- **telescope.nvim (+ ui-select, fzf)**: Project-wide search, files, symbols, etc., with a consistent UI for selections.
- **conform.nvim**: Format-on-save with LSP fallback; `<leader>f` formats now.
- **which-key.nvim**: Pop-up hints for keymaps (discoverability) with grouped leader menus.
- **gitsigns.nvim**: Git hunk signs and quick actions in the gutter.
- **guess-indent.nvim**: Auto-detect indentation per file.

### Optional goodies added
- **blink.cmp**: Fast autocompletion engine (replaces nvim-cmp).
- **lazydev.nvim**: Better Lua LSP experience when editing your Neovim config/plugins.
- **todo-comments.nvim**: Highlights TODO/FIXME notes; searchable.
- **mason-tool-installer.nvim**: Ensures external tools like `stylua` are installed.

### Helpful defaults in `init.lua`
- **Split behavior**: `splitright`, `splitbelow` for predictable windows.
- **Live substitute**: `inccommand='split'` previews `:%s` changes.
- **Visualize invisibles**: `list` + `listchars` for cleaner diffs.
- **Ergonomics**: `scrolloff=10`, `confirm=true`.
- **Window nav**: `<C-h/j/k/l>` to hop between splits.

## Repo layout
```
nvim/
  init.lua
  lua/
    plugins/        # your lazy.nvim specs (e.g., lua/plugins/init.lua)
```

