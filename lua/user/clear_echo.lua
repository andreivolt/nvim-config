-- Auto-clear command line messages after delay
vim.opt.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd('echo ""')
    end, 1000)
  end,
})
