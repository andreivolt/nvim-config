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
  end,
  ft = "lua",
}
