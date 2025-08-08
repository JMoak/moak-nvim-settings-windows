return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Improve sorting performance - Windows-specific build command
      { 
        "nvim-telescope/telescope-fzf-native.nvim", 
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      -- File browser extension
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require('telescope.builtin')
      
      telescope.setup({
        defaults = {
          -- Windows-specific configuration for ripgrep
          find_command = { "rg.exe", "--files", "--hidden", "--glob", "!**/.git/*" },
          
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
            },
          },
          file_ignore_patterns = { "node_modules", ".git", "target", "dist", "build" },
          path_display = { "truncate" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.9,
              height = 0.85,
              preview_width = 0.5,
            },
          },
        },
        extensions = {
          file_browser = {
            theme = "dropdown",
            hijack_netrw = true,
            path = "%:p:h", -- Windows path compatibility
            cwd_to_path = true,
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            mappings = {
              ["i"] = {
                ["<C-w>"] = function() vim.cmd('normal vbd') end,
              },
              ["n"] = {
                ["N"] = require("telescope").extensions.file_browser.actions.create,
                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                ["/"] = function()
                  vim.cmd('startinsert')
                end
              },
            },
          },
          ["ui-select"] = { require('telescope.themes').get_dropdown() },
        },
      })
      
      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      telescope.load_extension("file_browser")
      pcall(telescope.load_extension, "ui-select")
      
      -- Keymaps
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }
      
      -- Find files
      keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", opts)
      -- Find in files (grep)
      keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", opts)
      -- Browse files
      keymap("n", "<leader>fb", "<cmd>Telescope file_browser<CR>", opts)
      -- Buffers
      keymap("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
      -- Help tags
      keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", opts)
      -- Git files
      keymap("n", "<leader>gf", "<cmd>Telescope git_files<CR>", opts)
      -- Resume last search
      keymap("n", "<leader>fr", "<cmd>Telescope resume<CR>", opts)
      -- Find string under cursor 
      keymap("n", "<leader>fw", "<cmd>Telescope grep_string<CR>", opts)
      -- Extras inspired by Kickstart
      keymap("n", "<leader>sh", builtin.help_tags, opts)                 -- [S]earch [H]elp
      keymap("n", "<leader>sd", builtin.diagnostics, opts)                -- [S]earch [D]iagnostics
      keymap("n", "<leader>s.", builtin.oldfiles, opts)                  -- [S]earch recent files
      keymap("n", "<leader>sn", function() builtin.find_files({ cwd = vim.fn.stdpath('config') }) end, opts) -- [S]earch [N]eovim files
    end
  }
}
