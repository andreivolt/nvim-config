return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    enabled = false,
    exclude = {
      filetypes = {
        'help',
      },
      buftypes = {
        'terminal',
        'nofile',
      }
    },
    indent = {
      char = "┊"
    }
  },
  event = "VeryLazy",
}
