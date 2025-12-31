-- Cursor animation (fast, unobtrusive, visible)
vim.g.neovide_cursor_animation_length = 0.06
vim.g.neovide_cursor_short_animation_length = 0.02
vim.g.neovide_cursor_trail_size = 0.7
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_cursor_smooth_blink = true
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_opacity = 0.7
vim.g.neovide_remember_window_size = false
vim.g.neovide_scroll_animation_length = 0.07
vim.g.neovide_window_blurred = true
vim.opt.linespace = -2

require("user.cursor_color")

-- vim.api.nvim_create_autocmd({"VimEnter", "BufWinEnter"}, {
--   callback = function()
--     if vim.bo.buftype == "" then vim.wo.winbar = "%f" end
--   end,
-- })
--
