return {
  "neovim/nvim-lspconfig",
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
      end,
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    -- Servers with default config
    local servers = {
      'bashls',
      'biome',
      'clojure_lsp',
      'lua_ls',
      'pyright',
      'rust_analyzer',
      'ruby_lsp',
      'ts_ls',
      'nixd',
    }

    for _, server in ipairs(servers) do
      lspconfig[server].setup({ capabilities = capabilities })
    end
  end,
  event = { "BufReadPre", "BufNewFile" }
}
