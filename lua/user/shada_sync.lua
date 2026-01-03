vim.api.nvim_create_autocmd({ 'FocusGained', 'FocusLost' }, {
  callback = function()
    if vim.fn.exists(':rshada') == 2 then
      vim.cmd('rshada')
      vim.cmd('wshada')
    end
  end,
})
