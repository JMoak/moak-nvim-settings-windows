return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      { "j-hui/fidget.nvim", opts = {} },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")

      -- Prefer blink.cmp capabilities if available; fallback to default
      local ok_blink, blink = pcall(require, 'blink.cmp')
      local capabilities = ok_blink and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "html",
          "cssls",
          "jsonls",
          "marksman",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({ capabilities = capabilities })
          end,
          lua_ls = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = { diagnostics = { globals = { "vim" } } },
              },
            })
          end,
        },
      })

      -- Ensure external tools via mason-tool-installer
      require('mason-tool-installer').setup({ ensure_installed = { 'stylua' } })

      -- Optional Nerd Font diagnostic signs
      local has_nerd = vim.g.have_nerd_font == true
      if has_nerd then
        local signs = {
          { name = 'DiagnosticSignError', text = '󰅚' },
          { name = 'DiagnosticSignWarn',  text = '󰀪' },
          { name = 'DiagnosticSignInfo',  text = '󰋽' },
          { name = 'DiagnosticSignHint',  text = '󰌶' },
        }
        for _, s in ipairs(signs) do vim.fn.sign_define(s.name, { text = s.text, texthl = s.name, numhl = '' }) end
      end

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { source = "if_many", spacing = 2 },
      })

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local opts = { buffer = ev.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.supports_method('textDocument/documentHighlight') then
            local group = vim.api.nvim_create_augroup('LspDocumentHighlight' .. ev.buf, { clear = true })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { group = group, buffer = ev.buf, callback = vim.lsp.buf.document_highlight })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { group = group, buffer = ev.buf, callback = vim.lsp.buf.clear_references })
          end

          if client and client.supports_method('textDocument/inlayHint') and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>th', function()
              local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
              vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
            end, { buffer = ev.buf, desc = 'Toggle Inlay Hints' })
          end
        end,
      })
    end
  },
  -- Lua dev experience for editing Neovim config/plugins
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Autocompletion: blink.cmp (replaces nvim-cmp)
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then return end
          return 'make install_jsregexp'
        end)(),
      },
    },
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = { default = { 'lsp', 'path', 'snippets', 'lazydev' } },
      snippets = { preset = 'luasnip' },
      signature = { enabled = true },
      fuzzy = { implementation = 'lua' },
    },
  },
}
