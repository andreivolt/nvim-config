return {
  "romgrk/barbar.nvim",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    animation = false,
    auto_hide = 1,
    focus_on_close = "previous",
    icons = {
      buffer_index = false,
      buffer_number = false,
      diagnostics = {
        [vim.diagnostic.severity.ERROR] = { enabled = true },
        [vim.diagnostic.severity.WARN] = { enabled = true },
      },
      gitsigns = {
        added = { enabled = true, icon = "+" },
        changed = { enabled = true, icon = "~" },
        deleted = { enabled = true, icon = "-" },
      },
      pinned = { button = "", filename = true },
      separator = { left = "▎", right = "" },
    },
  },
  keys = {
    { "<leader>bb", "<Cmd>BufferPick<CR>", desc = "pick" },
    { "<leader>bd", "<Cmd>BufferClose<CR>", desc = "close" },
    { "<leader>bx", "<Cmd>BufferPin<CR>", desc = "pin" },
    { "<leader>bo", "<Cmd>BufferCloseAllButCurrentOrPinned<CR>", desc = "close others" },
  },
}
