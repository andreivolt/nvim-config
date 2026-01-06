return {
  'Wansmer/treesj',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  keys = {
    { "<leader>m", "<cmd>TSJToggle<CR>", desc = "split/join" },
  },
  opts = {
    use_default_keymaps = false,
    max_join_length = math.huge
  },
  cmd = {
    "TSJJoin",
    "TSJSplit",
    "TSJToggle",
  },
}
