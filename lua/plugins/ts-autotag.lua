return {
  'windwp/nvim-ts-autotag',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
  event = { 'BufReadPre', 'BufNewFile' },
}
