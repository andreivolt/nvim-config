return {
  "neovim/nvim-lspconfig",
  dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- { 'j-hui/fidget.nvim', opts = {} },
      -- { 'folke/neodev.nvim', opts = {} },
    },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }
        -- navigation
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
        -- info
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('i', '<C-x><C-x>', vim.lsp.buf.signature_help, opts)
        -- actions
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format({ async = true }) end, opts)
        -- diagnostics
        vim.keymap.set('n', '[a', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
        vim.keymap.set('n', ']a', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
        vim.keymap.set('n', '<Leader>a', vim.diagnostic.open_float, opts)
        -- workspace
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)

        -- show diagnostics on cursor hold
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = ev.buf,
          callback = function()
            vim.diagnostic.open_float(nil, {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              source = "always",
              prefix = " ",
              scope = "cursor",
            })
          end
        })

        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = ev.buf,
          callback = function()
            vim.lsp.buf.format({ async = false })
          end,
        })
      end,
    })

    require("mason").setup()

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- require('mason-lspconfig').setup {
    --   handlers = {
    --     function(server_name)
    --       local server = servers[server_name] or {}
    --       server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
    --       require('lspconfig')[server_name].setup(server)
    --     end,
    --   },
    -- }

    -- Check if running on Termux
    local is_termux = vim.fn.isdirectory('/data/data/com.termux') == 1

    local config = {
      handlers = {
        -- Default handler for all servers
        function(server_name)
          require('lspconfig')[server_name].setup({ capabilities = capabilities })
        end,
        -- lua_ls with navic integration
        lua_ls = function()
          require('lspconfig').lua_ls.setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
              require("nvim-navic").attach(client, bufnr)
            end,
          })
        end,
      }
    }

    -- Only auto-install servers if not on Termux
    if not is_termux then
      config.ensure_installed = {
        'bashls',
        'biome',
        'clojure_lsp',
        'lua_ls',
        -- 'nil_ls',
        'pyright',
        'rust_analyzer',
        -- 'ruby_lsp', -- Using system ruby-lsp instead
        'ts_ls',
        -- 'gopls',
      }
    end

    require('mason-lspconfig').setup(config)
  end,
  event = "VeryLazy"
}
