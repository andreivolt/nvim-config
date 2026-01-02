return {
  'echasnovski/mini.nvim',
  event = "BufReadPost",
  config = function()
    -- Subtle statusline diagnostic colors
    vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#994444", bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#997744", bg = "NONE" })

    require('mini.statusline').setup({
      content = {
        active = function()
          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 9999 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local line = vim.fn.line('.')
          local total = vim.fn.line('$')
          local location = string.format("ℓ %d │ %d", line, total)

          -- Custom diagnostics: semantic colors
          local diag = vim.diagnostic.count(0)
          local e, w = diag[vim.diagnostic.severity.ERROR] or 0, diag[vim.diagnostic.severity.WARN] or 0
          local err_str = e > 0 and " ✕ " .. e .. " " or ""
          local warn_str = w > 0 and " ! " .. w .. " " or ""

          local is_normal = vim.fn.mode():sub(1, 1) == "n"
          local loc_hl = is_normal and "Comment" or mode_hl
          local mode_bar_hl = is_normal and "Comment" or mode_hl

          return MiniStatusline.combine_groups({
            { hl = mode_bar_hl, strings = { " " } },
            { hl = "MiniStatuslineDevinfo", strings = { " " .. git .. " │ " } },
            { hl = "MiniStatuslineFilename", strings = { filename } },
            "%=",
            { hl = loc_hl, strings = { " " .. location .. " " } },
            { hl = "StatusLineWarn", strings = { warn_str } },
            { hl = "StatusLineError", strings = { err_str } },
          })
        end,
      },
    })
  end,
}
