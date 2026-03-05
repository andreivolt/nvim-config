return {
  "SmiteshP/nvim-navic",
  dependencies = "neovim/nvim-lspconfig",
  config = function()
    local navic = require("nvim-navic")
    navic.setup({
      lsp = { auto_attach = true },
      highlight = false,
    })

    local segment_bg = "#3a3a50"
    local segment_fg = "#ccccdd"
    local sep_l = "\u{e0b6}"
    local sep_r = "\u{e0b4}"

    local function set_winbar_hl()
      vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "WinBarSegmentL", { fg = segment_bg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "WinBarSegment", { fg = segment_fg, bg = segment_bg })
      vim.api.nvim_set_hl(0, "WinBarSegmentR", { fg = segment_bg, bg = "NONE" })
    end

    set_winbar_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_winbar_hl })

    vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "CursorMovedI" }, {
      callback = function()
        if vim.bo.buftype ~= "" then return end
        if not navic.is_available() then
          vim.wo.winbar = ""
          return
        end

        local location = navic.get_location()
        if location == "" then
          vim.wo.winbar = ""
        else
          vim.wo.winbar = "%#WinBarSegmentL#" .. sep_l .. "%#WinBarSegment# " .. location .. " %#WinBarSegmentR#" .. sep_r
        end
      end,
    })
  end,
}
