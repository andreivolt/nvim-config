-- ufo.nvim handles foldexpr/foldmethod via provider_selector
vim.opt.fillchars = {
  vert = "▏",
  fold = " ",
  foldclose = "▸",
  foldopen = "▾",
}

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    if vim.bo.buftype ~= "" then return end

    vim.opt_local.statuscolumn = [[%{(foldlevel(v:lnum) && foldlevel(v:lnum) > foldlevel(v:lnum - 1)) ? (foldclosed(v:lnum) == -1 ? '⌄' : '›') : ' '}]] .. ' ' .. '%=%{v:virtnum < 1 ? (v:lnum) : " "}' .. '%s'
  end,
})
