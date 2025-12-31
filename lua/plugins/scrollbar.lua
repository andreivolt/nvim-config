return {
  'petertriho/nvim-scrollbar',
  dependencies = { "kevinhwang91/nvim-hlslens" },
  config = function()
    require("scrollbar").setup({ handlers = { cursor = false } })
    require("scrollbar.handlers.search").setup()
  end,
  event = "VeryLazy",
}
