return {
  "norcalli/nvim-colorizer.lua",
  event = {
    'BufNewFile',
    'BufReadPost',
  },
  config = function()
    require("colorizer").setup({ '*' }, {
      names = false,
      rgb_fn = true,
      hsl_fn = true,
    })
  end,
}
