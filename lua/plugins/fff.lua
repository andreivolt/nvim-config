return {
  'dmtrKovalenko/fff.nvim',
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  keys = {
    { "<leader>ff", function() require('fff').find_files() end, desc = "Find files" },
    { "<leader>fF", function() require('fff').find_in_git_root() end, desc = "Find files (git root)" },
  },
}
