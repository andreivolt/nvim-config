-- vim.api.nvim_create_autocmd("ColorScheme", {
--   pattern = "*",
--   callback = function()
--     vim.api.nvim_set_hl(0, "Comment", { fg = "#777777", italic = true })
--     vim.api.nvim_set_hl(0, "Folded", { fg = "#aaaaaa" })
--     vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
--     vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = "#333333" })
--     vim.api.nvim_set_hl(0, "Pmenu", { bg = "#111111" })
--     vim.api.nvim_set_hl(0, "Question", { fg = "#444444" })
--     vim.api.nvim_set_hl(0, "SpellBad", { bg = "NONE", fg = "NONE", sp = "red", undercurl = true })
--     vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = "#333333" })
--     vim.api.nvim_set_hl(0, "WinSeparator", { bg = "black", fg = "#333333" })
--     vim.api.nvim_set_hl(0, "ZenBg", { bg = "black" })
--
--     -- vim.api.nvim_set_hl(0, "CmpPmenuBorder", { bg = "#333333" })
--   end,
-- })

vim.cmd([[syn match URL /http[s]\?:\/\/[[:alnum:]%\/_#.-]*/ containedin=ALL]])
vim.api.nvim_set_hl(0, "URL", { underline = true, fg = "skyblue" })

vim.cmd("colorscheme aurora")

-- Apply immediately after colorscheme load
vim.api.nvim_set_hl(0, "WinSeparator", { link = "Comment" })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Make Normal background transparent
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

    -- Window separator same color as comments
    vim.api.nvim_set_hl(0, "WinSeparator", { link = "Comment" })

    -- Subtle floating window borders (global + plugin-specific)
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#555555" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "CmpPmenuBorder", { link = "FloatBorder" })

    -- Treesitter context background
    vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#1a1a1a" })

    -- Darker diff colors for gitsigns preview (muted, dark tones)
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#092C00" })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3F0600" })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2a2a33" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#33332a" })

    -- Gitsigns inline word diff (using aurora's dark colors)
    vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#3e5e20" })      -- aurora darkgreen
    vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#661a1a" })   -- aurora darkred
    vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#144a66" })   -- aurora darkblue
    vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#3e5e20" })
    vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#661a1a" })
    vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { bg = "#144a66" })

    -- Indent guides: faded inactive, subtle active
    vim.api.nvim_set_hl(0, "IblIndent", { fg = "#262631" })              -- aurora accent_3 (very faded)
    vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3f3866" })  -- aurora darkpurple

    -- Handle EndOfBuffer coloring
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    if normal_hl.bg then
      local bg_color = string.format("#%06x", normal_hl.bg)
      local MiniColors = require('mini.colors')

      -- Use modify_channel to darken the lightness
      local darkened_bg = MiniColors.modify_channel(bg_color, 'lightness', function(l) return l * 0.5 end)

      vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = darkened_bg, bg = darkened_bg })
    end
  end,
})

-- Apply transparent background to current colorscheme
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#555555" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "LspInfoBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "CmpPmenuBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#1a1a1a" })
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#092C00" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3F0600" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#2a2a33" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#33332a" })
vim.api.nvim_set_hl(0, "GitSignsAddInline", { bg = "#3e5e20" })
vim.api.nvim_set_hl(0, "GitSignsDeleteInline", { bg = "#661a1a" })
vim.api.nvim_set_hl(0, "GitSignsChangeInline", { bg = "#144a66" })
vim.api.nvim_set_hl(0, "GitSignsAddLnInline", { bg = "#3e5e20" })
vim.api.nvim_set_hl(0, "GitSignsDeleteLnInline", { bg = "#661a1a" })
vim.api.nvim_set_hl(0, "GitSignsChangeLnInline", { bg = "#144a66" })
vim.api.nvim_set_hl(0, "IblIndent", { fg = "#262631" })
vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3f3866" })
