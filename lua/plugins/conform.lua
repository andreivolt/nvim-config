return {
  'stevearc/conform.nvim',
  event = "BufWritePre",
  opts = {
    format_on_save = false,
    formatters_by_ft = {
      python = { "ruff_format" },
      sh = { "shfmt" },
    },
  },
}
