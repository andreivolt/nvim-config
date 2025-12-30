return {
  'echasnovski/mini.nvim',
  event = "VeryLazy",
  config = function()
    require('mini.colors').setup()
    require('mini.bracketed').setup()
    require('mini.indentscope').setup({
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    })
  end
}
