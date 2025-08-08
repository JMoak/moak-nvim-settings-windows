return {
  -- Status Line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = '|', right = '|'},
          section_separators = { left = '', right = ''},
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
      })
    end
  },
  
  -- File Explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        hijack_cursor = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        sort_by = "case_sensitive",
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        on_attach = function(bufnr)
          -- prevent accidental gitsigns attach into NvimTree buffer
          vim.b[bufnr].gitsigns_status = 'skip'
        end,
      })
      
      -- Keymaps
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { noremap = true, silent = true })
    end
  },
  
  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end
  },
  
  -- Notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end
  },
  
  -- Better UI for code actions, hover, etc
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that cmp and other plugins use Treesitter
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end
  },
  
  -- Which Key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.setup({
        notify = false,
        -- Limit triggers to <leader> to avoid operator-family overlap checks
        triggers = {
          { "<leader>", mode = "n" },
          { "<leader>", mode = "v" },
        },
      })
      -- New spec format to label groups
      wk.add({
        { "<leader>s", group = "[S]earch" },
        { "<leader>t", group = "[T]oggle" },
        { "<leader>g", group = "[G]it" },
        -- Skip <leader>f group label to avoid overlap warning with ff/fg/etc
        { "<leader>x", group = "Diagnostics/Trouble" },
      })
    end
  },
}
