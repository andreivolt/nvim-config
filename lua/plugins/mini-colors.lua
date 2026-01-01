return {
  'echasnovski/mini.nvim',
  event = "VeryLazy",
  config = function()
    require('mini.colors').setup()
    require('mini.bracketed').setup()
    require('mini.indentscope').setup({
      symbol = '┊',
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NvimTree" },
      callback = function() vim.b.miniindentscope_disable = true end,
    })
  end
}
