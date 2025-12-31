-- Equalize window sizes on terminal resize
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd.wincmd("=")
  end,
})
