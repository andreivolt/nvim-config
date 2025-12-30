return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    max_lines = 0,  -- no limit
    mode = "topline",
    multiline_threshold = 2,  -- skip single-line contexts (fixes bash one-liner bug)
  },
  event = "VeryLazy"
}
