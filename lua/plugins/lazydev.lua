return {
  "folke/lazydev.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    'hrsh7th/nvim-cmp',
    "SmiteshP/nvim-navic",
  },
  init = function()
    vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
  end,
  config = function()
    require("lazydev").setup()

    local navic = require("nvim-navic")

    require("lspconfig").lua_ls.setup({
      root_dir = require("lspconfig.util").root_pattern(".git", ".luarc.json", ".luarc.jsonc", "init.lua"),
      on_attach = function(client, bufnr)
          navic.attach(client, bufnr)
      end
    })
  end,
  ft = "lua",
}
