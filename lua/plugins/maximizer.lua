return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  keys = {
    { "<C-w>m", "<cmd>WindowsMaximize<cr>", desc = "maximize" },
    { "<C-w>_", "<cmd>WindowsMaximizeVertically<cr>", desc = "max vertical" },
    { "<C-w>|", "<cmd>WindowsMaximizeHorizontally<cr>", desc = "max horizontal" },
    { "<C-w>=", "<cmd>WindowsEqualize<cr>", desc = "equalize" },
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
