function MyFoldText()
  local indent = vim.fn.indent(vim.v.foldstart) - vim.o.shiftwidth
  return string.rep(' ', indent) .. '+' .. string.rep('-', vim.o.shiftwidth - 2) .. ' ' .. string.gsub(vim.fn.getline(vim.v.foldstart), '^%s*', '')
end

vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.wo.foldminlines = 0
vim.wo.foldmethod = 'indent'
vim.wo.foldtext = 'v:lua.MyFoldText()'
