return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Windows-specific Treesitter configuration
      require("nvim-treesitter.install").prefer_git = false -- Use curl instead of git
      
      -- If using Zig as the compiler (recommended)
      require("nvim-treesitter.install").compilers = { "zig" }
      
      -- If using MSYS2/MinGW
      -- require("nvim-treesitter.install").compilers = { "gcc" }
      
      -- If using Visual Studio Build Tools
      -- require("nvim-treesitter.install").compilers = { "cl" }
      
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vimdoc",
          "query",
          "javascript",
          "typescript",
          "tsx",
          "html",
          "css",
          "json",
          "yaml",
          "python",
          "markdown",
          "markdown_inline",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
        -- Add more modules as needed
      })
    end
  },
  
  -- Treesitter context (shows function/block context at top of screen)
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup()
    end
  },
}
