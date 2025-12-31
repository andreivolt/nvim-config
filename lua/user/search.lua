-- Tab/S-Tab to jump to next/previous search match while in search mode
vim.keymap.set('c', '<Tab>', function()
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    return '<CR>/<C-r>/'
  else
    return '<C-z>'
  end
end, { expr = true })

vim.keymap.set('c', '<S-Tab>', function()
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    return '<CR>?<C-r>/'
  else
    return '<S-Tab>'
  end
end, { expr = true })
