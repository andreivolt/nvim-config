return {
  "folke/which-key.nvim",
  keys = "<leader>",
  init = function()
    vim.opt.timeout = true
    vim.opt.timeoutlen = 300
  end,
  opts = {
    icons = {
      mappings = false,
      group = "",
    },
    win = {
      border = "single",
      padding = { 0, 0 },
    },
    spec = {
      { "<leader>b", group = "buffer" },
      { "<leader>f", group = "find" },
      { "<leader>h", group = "hunk" },
      { "<leader>t", group = "toggle" },
      { "<leader>a", group = "arglist" },
      { "<leader>c", group = "quickfix" },
    },
  },
}
