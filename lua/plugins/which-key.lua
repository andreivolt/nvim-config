return {
  "folke/which-key.nvim",
  keys = "<leader>",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  opts = {
    win = {
      border = "single",
      padding = { 0, 0 },
    },
  },
}
