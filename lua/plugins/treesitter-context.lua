return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    max_lines = 0,
    mode = "topline",
    separator = "⎯",
  },
  config = function(_, opts)
    require("treesitter-context").setup(opts)
    local set_hl = function()
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "NONE" })
    end
    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_hl })
  end,
  event = "VeryLazy"
}
