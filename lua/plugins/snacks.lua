return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    notifier = { enabled = true },
    picker = {
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "i", "n" } },
            ["<C-u>"] = false,
          },
        },
      },
      sources = {
        files = { layout = { preset = "dropdown" } },
        buffers = { layout = { preset = "dropdown" } },
        grep = { layout = { preset = "dropdown" } },
        git_log_file = { layout = { preset = "dropdown" } },
      },
    },
  },
  keys = {
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
    { "<leader>fh", function() Snacks.picker.git_log_file() end, desc = "File git history" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
  },
}
