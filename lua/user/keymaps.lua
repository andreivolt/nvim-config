vim.keymap.set("n", "<esc>", vim.cmd.nohlsearch)

vim.keymap.set("n", "<leader><leader>", function()
  if vim.fn.expand("#") == "" then return end
  vim.cmd("edit #")
end)

vim.keymap.set("n", "<leader>bn", vim.cmd.bnext)
vim.keymap.set("n", "<leader>bd", vim.cmd.bdelete)
vim.keymap.set("n", "<leader>bp", vim.cmd.bprev)
vim.keymap.set("n", "<leader>q", vim.cmd.q)

vim.keymap.set("n", "<leader>gd", function()
  local file_path = vim.fn.expand('%:p')
  vim.cmd('bdelete!')
  local ok, err = vim.uv.fs_unlink(file_path)
  if ok then
    vim.notify('File deleted: ' .. vim.fn.fnamemodify(file_path, ':t'), vim.log.levels.INFO)
  else
    vim.notify('Failed: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
  end
end)

vim.keymap.set("n", "gp", "[v]")

vim.keymap.set("v", "<tab>", ">gv")
vim.keymap.set("v", "<s-tab>", "<gv")
vim.keymap.set("n", "<tab>", ">>")
vim.keymap.set("n", "<s-tab>", "<<")
vim.keymap.set("n", "<C-i>", "<C-i>") -- preserve jump forward (distinct from Tab with CSI u)

vim.keymap.set("n", "<leader>tn", function() vim.opt.number = not vim.opt.number:get() end)
vim.keymap.set("n", "<leader>ts", function() vim.opt.spell = not vim.opt.spell:get() end)

vim.keymap.set("n", "<leader>u", function()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.fn.col(".")
  local urls = {}

  for url in string.gmatch(line, "https?://[%w-_./?%%=~&:+%%*@]+") do
    table.insert(urls, url)
  end

  if #urls == 0 then return end

  if #urls == 1 then
    vim.ui.open(urls[1])
  else
    local found_url = false
    for _, url in ipairs(urls) do
      local s, e = string.find(line, url, 1, true)
      if cursor_col >= s and cursor_col <= e then
        vim.ui.open(url)
        found_url = true
        break
      end
    end
    if not found_url then
      for _, url in ipairs(urls) do
        vim.ui.open(url)
      end
    end
  end
end)

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "gf", function() vim.cmd("edit <cfile>") end)

vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")

vim.keymap.set('x', 'v', require('nvim-treesitter.incremental_selection').node_incremental)
vim.keymap.set('x', 'V', require('nvim-treesitter.incremental_selection').node_decremental)

vim.keymap.set("n", "gV", "'[V']")

vim.keymap.set("n", "<leader>an", vim.cmd.next)
vim.keymap.set("n", "<leader>ap", vim.cmd.prev)

vim.keymap.set("n", "<leader>cn", vim.cmd.cnext)
vim.keymap.set("n", "<leader>cp", vim.cmd.cprev)


vim.keymap.set("v", "y", function() return 'my"' .. vim.v.register .. "y`y" end, { expr = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "center search hits vertically on screen and expand folds if hit is inside" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "center search hits vertically on screen and expand folds if hit is inside" })
-- vim.keymap.set("v", "y", "ygv<Esc>") -- TODO

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "lspinfo",
    "qf",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
