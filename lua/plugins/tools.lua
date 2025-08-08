return {
  -- Comment code
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },
  
  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      attach_to_untracked = true,
      on_attach = function(bufnr)
        if vim.bo[bufnr].filetype == 'NvimTree' then
          return false
        end
      end,
    },
  },
  
  -- Git commands
  { "tpope/vim-fugitive", lazy = false },
  
  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end
  },
  
  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<c-\>]],
        direction = "float",
        float_opts = {
          border = "curved",
        },
      })
    end
  },
  
  -- Trouble for diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup()
      
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
        {silent = true, noremap = true}
      )
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
        {silent = true, noremap = true}
      )
    end
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = { lua = { 'stylua' } },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
