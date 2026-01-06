return {
  'stevearc/oil.nvim',
  dependencies = { { "nvim-tree/nvim-web-devicons", opts = {} } },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "oil" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
}
