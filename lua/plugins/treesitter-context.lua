return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    max_lines = 0,  -- no limit
    mode = "topline"
  },
  event = "VeryLazy"
}
