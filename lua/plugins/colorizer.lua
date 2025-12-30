return {
  "NvChad/nvim-colorizer.lua",
  event = {
    'BufNewFile',
    'BufReadPost',
  },
  opts = {
    filetypes = {
      'css',
      'html',
      'javascript',
      'lua',
    },
  },
}
