return {
  "folke/snacks.nvim",
  opts = {
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
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "buffers" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "grep" },
    { "<leader>fh", function() Snacks.picker.git_log_file() end, desc = "git history" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "recent" },
  },
}
