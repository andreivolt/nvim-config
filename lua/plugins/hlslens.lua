local kopts = { mode = "n", silent = true }

-- Run a normal-mode search motion; on failure (E486 pattern not found etc.) show the plain error message instead of a lua traceback, and skip starting the lens.
local function search(cmd)
  return function()
    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
      vim.notify(err:match("E%d+:.*") or err, vim.log.levels.ERROR)
      return
    end
    require('hlslens').start()
  end
end

return {
  "kevinhwang91/nvim-hlslens",
  config = function()
    require('hlslens').setup()
  end,
  keys = {
    { 'n', function() search('execute "normal! " . v:count1 . "n"')() end, kopts },
    { 'N', function() search('execute "normal! " . v:count1 . "N"')() end, kopts },
    { '*', search('normal! *'), kopts },
    { '#', search('normal! #'), kopts },
    { 'g*', search('normal! g*'), kopts },
    { 'g#', search('normal! g#'), kopts },
  },
}
