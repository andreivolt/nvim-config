-- Auto-reload files changed outside vim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "silent! checktime",
})

-- checktime skips background buffers, causing false "modified" prompts on quit
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    vim.cmd("silent! checktime")
  end,
})
