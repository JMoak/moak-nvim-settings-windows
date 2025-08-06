return {
  -- Color scheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-moon]])
    end,
  },
  
  -- Plenary (dependency for many plugins)
  { "nvim-lua/plenary.nvim" },
  
  -- Better UI components
  { "MunifTanjim/nui.nvim" },
  
  -- File icons
  { "nvim-tree/nvim-web-devicons" },
}
