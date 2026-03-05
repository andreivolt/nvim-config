return {
  'echasnovski/mini.nvim',
  event = "BufReadPost",
  config = function()
    local segment_bg = "#3a3a50"
    local segment_fg = "#ccccdd"
    local file_bg = "#2a2a3a"
    local file_fg = "#999999"

    local function set_statusline_hl()
      -- Rounded segment highlights
      vim.api.nvim_set_hl(0, "StatusSegmentL", { fg = segment_bg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusSegment", { fg = segment_fg, bg = segment_bg })
      vim.api.nvim_set_hl(0, "StatusSegmentR", { fg = segment_bg, bg = "NONE" })
      -- File segment (different bg)
      vim.api.nvim_set_hl(0, "StatusFileL", { fg = file_bg, bg = segment_bg })
      vim.api.nvim_set_hl(0, "StatusFile", { fg = file_fg, bg = file_bg })
      vim.api.nvim_set_hl(0, "StatusFileR", { fg = file_bg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusFileLOnly", { fg = file_bg, bg = "NONE" })

      -- Diagnostic colors (no bg)
      vim.api.nvim_set_hl(0, "StatusLineError", { fg = "#994444", bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineWarn", { fg = "#997744", bg = "NONE" })

      -- Transparent statusline background
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineDevinfo", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineFileinfo", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeNormal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeVisual", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeReplace", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeCommand", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineModeOther", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { bg = "NONE" })
    end

    set_statusline_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_statusline_hl })

    require('mini.statusline').setup({
      content = {
        active = function()
          if vim.bo.filetype == "NvimTree" then return nil end

          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local line = vim.fn.line('.')
          local total = vim.fn.line('$')
          local location = string.format("ℓ %d │ %d", line, total)

          local diag = vim.diagnostic.count(0)
          local e, w = diag[vim.diagnostic.severity.ERROR] or 0, diag[vim.diagnostic.severity.WARN] or 0
          local err_str = e > 0 and "%#StatusLineError# ✕ " .. e or ""
          local warn_str = w > 0 and "%#StatusLineWarn# ! " .. w or ""

          local sep_l = "\u{e0b6}"
          local sep_r = "\u{e0b4}"

          local left_pill
          if git and git ~= "" then
            left_pill = "%#StatusSegmentL#" .. sep_l .. "%#StatusSegment# " .. git .. " %#StatusFileL#" .. sep_l .. "%#StatusFile# " .. filename .. " %#StatusFileR#" .. sep_r
          else
            left_pill = "%#StatusFileLOnly#" .. sep_l .. "%#StatusFile# " .. filename .. " %#StatusFileR#" .. sep_r
          end

          local loc_pill = "%#StatusSegmentL#" .. sep_l .. "%#StatusSegment# " .. location .. " %#StatusSegmentR#" .. sep_r

          return left_pill .. "%=" .. warn_str .. err_str .. " " .. loc_pill
        end,
        inactive = function()
          if vim.bo.filetype == "NvimTree" then return nil end

          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local sep_l = "\u{e0b6}"
          local sep_r = "\u{e0b4}"

          return "%#StatusFileLOnly#" .. sep_l .. "%#StatusFile# " .. filename .. " %#StatusFileR#" .. sep_r
        end,
      },
    })
  end,
}
