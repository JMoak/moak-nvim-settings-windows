vim.notify = function(msg, ...)
  if msg:match("nvim%-treesitter") then
    return
  end
  return require("vim.notify")(msg, ...)
end

vim.g.ts_skip_cleanup = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
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

-- Windows-specific options
vim.opt.shellslash = true       -- Use forward slashes on Windows

-- Terminal mappings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

-- Create a custom command for Claude Code side-by-side
vim.api.nvim_create_user_command('ClaudeCode', function()
  vim.cmd('Vexplore | rightbelow vsplit | term claude')
  vim.cmd('wincmd L') --throw claudecode to the rightk
  vim.cmd('wincmd h | wincmd h') -- some odd manipulation to activate Vexplore contextual resizing
  vim.cmd('wincmd l | wincmd l | startinsert') -- back to claude for input
end, {})

-- Edit file in left split (with optional filename)
vim.api.nvim_create_user_command('EditLeft', function(opts)
  if opts.args == '' then
    -- No filename provided, open file explorer in left split
    vim.cmd('Vexplore ./')
  else
    -- Filename provided, open that file
    vim.cmd('leftabove vsplit ' .. opts.args)
  end
end, {
  nargs = '?',  -- Optional argument
  complete = 'file',  -- File completion when typing
  desc = 'Edit file in left split'
})

-- Load plugins
require("lazy").setup("plugins")
