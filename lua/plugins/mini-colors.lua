return {
  'echasnovski/mini.nvim',
  event = "VeryLazy",
  config = function()
    require('mini.colors').setup()
    require('mini.bracketed').setup()
    require('mini.statusline').setup({
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { "" } },  -- color only, no text
            { hl = "MiniStatuslineDevinfo", strings = { git } },
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
            { hl = mode_hl, strings = { location } },
          })
        end,
      },
    })
    require('mini.indentscope').setup({
      symbol = '┊',
      draw = {
        delay = 0,
        animation = require('mini.indentscope').gen_animation.none(),
      },
    })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NvimTree" },
      callback = function() vim.b.miniindentscope_disable = true end,
    })
  end
}
