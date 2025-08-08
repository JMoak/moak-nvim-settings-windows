--[[
     ╭─────────────────────────────────────────────────────────────────╮
     │  ┌─────────────────────────────────────────────────────────────┐ │
     │  │                                                             │ │
     │  │                                                             │ │
     │  │  > Terminal online...                                       │ │
     │  │                                                             │ │
     │  └─────────────────────────────────────────────────────────────┘ │
     ╰─────────────────────────────────────────────────────────────────╯

═══════════════════════════════════════════════════════════════════════════════
--]]

-- Route notifications; drop noisy Treesitter install/update messages
vim.notify = function(msg, ...)
  if msg:match("nvim%-treesitter") then
    return
  end
  return require("vim.notify")(msg, ...)
end

-- Hint flag to avoid Treesitter cleanup thrash (harmless if unused)
vim.g.ts_skip_cleanup = true

-- Bootstrap lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy
vim.g.mapleader = " " -- Space as leader key

-- Basic Options
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Show relative line numbers
vim.opt.tabstop = 2             -- Number of spaces tabs count for
vim.opt.shiftwidth = 2          -- Size of an indent
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.smartindent = true      -- Insert indents automatically
vim.opt.termguicolors = true    -- True color support
vim.opt.updatetime = 100        -- Faster completion
vim.opt.cursorline = true       -- Highlight current line
vim.opt.signcolumn = "yes"      -- Always show sign column
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.ignorecase = true       -- Ignore case when searching
vim.opt.smartcase = true        -- Don't ignore case with capitals

-- Window behavior
vim.opt.splitright = true       -- New vertical splits open to the right
vim.opt.splitbelow = true       -- New horizontal splits open below
vim.opt.scrolloff = 10          -- Keep cursor with context above/below
vim.opt.confirm = true          -- Ask before closing unsaved buffers

-- Live substitution preview
vim.opt.inccommand = "split"    -- Preview :%s replacements in a split

-- Visualize invisible chars when needed
vim.opt.list = true             -- Show invisible characters
vim.opt.listchars = {           -- Glyphs for invisibles
  tab = '» ',
  trail = '·',
  nbsp = '␣',
}

-- Windows-specific options
vim.opt.shellslash = false      -- Use forward slashes on Windows

-- Terminal mode: <Esc> leaves terminal-mode (sends <C-\\><C-n>)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Normal mode: <Esc> clears incremental search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { noremap = true })

-- Fast window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Window left' })  -- Ctrl+h to left window
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Window right' }) -- Ctrl+l to right window
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Window down' })  -- Ctrl+j to lower window
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Window up' })    -- Ctrl+k to upper window

-- Flash yanked text to confirm successful yank (TextYankPost autocmd)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('moak-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Create a custom command for Claude Code side-by-side
vim.api.nvim_create_user_command('ClaudeCode', function()
  vim.cmd('Vexplore | rightbelow vsplit | term claude')
  vim.cmd('wincmd L') --throw claudecode to the rightk
  vim.cmd('wincmd h | wincmd h') -- some odd manipulation to activate Vexplore contextual resizing
  vim.cmd('wincmd l | wincmd l | startinsert') -- back to claude for input
end, {})

-- Custom command: open a file (or Explorer) in the left split
vim.api.nvim_create_user_command('EditLeft', function(opts)
  if opts.args == '' then
    -- No filename provided, open file explorer in left split
    vim.cmd('Vexplore ./')
  else
    -- Filename provided, open that file
    vim.cmd('leftabove vsplit ' .. opts.args)
  end
end, { nargs = '?', complete = 'file', desc = 'Edit file in left split' })

-- Load plugin specs from lua/plugins/** via lazy.nvim
require("lazy").setup("plugins")
