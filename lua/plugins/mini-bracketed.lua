return {
  'echasnovski/mini.nvim',
  event = "VeryLazy",
  config = function()
    require('mini.bracketed').setup()
  end,
}
