return {
  'echasnovski/mini.nvim',
  event = "BufReadPost",
  config = function()
    require('mini.statusline').setup({
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local location = MiniStatusline.section_location({ trunc_width = 75 })

          -- Custom diagnostics: just numbers, no icons
          local diag = vim.diagnostic.count(0)
          local e, w = diag[vim.diagnostic.severity.ERROR] or 0, diag[vim.diagnostic.severity.WARN] or 0
          local diag_str = (e > 0 or w > 0) and string.format(" E%d W%d ", e, w) or ""

          local loc_hl = vim.fn.mode() == "n" and "Comment" or mode_hl

          return MiniStatusline.combine_groups({
            { hl = mode_hl, strings = { " " } },  -- color only, no text
            { hl = "MiniStatuslineDevinfo", strings = { " " .. git .. " " } },
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = loc_hl, strings = { " " .. location .. " " } },
            { hl = "DiagnosticError", strings = { diag_str } },
          })
        end,
      },
    })
  end,
}
