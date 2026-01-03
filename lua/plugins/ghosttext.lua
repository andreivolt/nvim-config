return {
  'subnut/nvim-ghost.nvim',
  enabled = false,
  init = function()
    vim.g.nvim_ghost_super_quiet = 1
  end,
  event = "VeryLazy",
}
