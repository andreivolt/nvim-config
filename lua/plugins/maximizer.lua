return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  keys = {
    { "<C-w>m", "<cmd>WindowsMaximize<cr>" },
    { "<C-w>_", "<cmd>WindowsMaximizeVertically<cr>" },
    { "<C-w>|", "<cmd>WindowsMaximizeHorizontally<cr>" },
    { "<C-w>=", "<cmd>WindowsEqualize<cr>" },
  },
  opts = {
    autowidth = {
      enable = false,
    },
    animation = {
      enable = true,
      duration = 75,
    },
  },
}
