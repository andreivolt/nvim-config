return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  opts = {
    keymaps = {
      move_up = '<C-k>',
      move_down = '<C-j>',
      preview_scroll_up = false,  -- allow C-u to clear line
    },
  },
  keys = {
    { "<leader>ff", function() require('fff').find_files() end, desc = "Find files" },
    { "<leader>fF", function() require('fff').find_in_git_root() end, desc = "Find files (git root)" },
  },
}
