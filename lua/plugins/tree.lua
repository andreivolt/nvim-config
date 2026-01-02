return {
  'nvim-tree/nvim-tree.lua',
  dependencies =  'nvim-tree/nvim-web-devicons',
  keys = {
    {"<leader>n", "<cmd>NvimTreeFindFileToggle<cr>"},
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    local ns = vim.api.nvim_create_namespace("nvimtree_hl")
    vim.api.nvim_set_hl(ns, "WinBar", { link = "Normal" })
    vim.api.nvim_set_hl(ns, "WinBarNC", { link = "Normal" })
    vim.api.nvim_set_hl(ns, "StatusLine", { link = "Normal" })
    vim.api.nvim_set_hl(ns, "StatusLineNC", { link = "Normal" })
    vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { link = "Normal" })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "NvimTree_*",
      callback = function()
        vim.api.nvim_win_set_hl_ns(0, ns)
        vim.wo.statusline = "%#NvimTreeStatusLine#"
        vim.wo.fillchars = "eob: "
      end,
    })
  end,
  opts = {
    git = {
      enable = false,
    },
    disable_netrw = true,
    hijack_cursor = true,
    sync_root_with_cwd = true,
    filesystem_watchers = {
      ignore_dirs = {
        "node_modules",
        ".git",
        "/Users/andrei/Library",
        "/System",
        "/Applications",
        "/usr",
        "/opt",
      },
    },
    renderer = {
      highlight_git = true,
      highlight_opened_files = "all",
      root_folder_label = false,
      icons = {
        show = {
          file = false,
          folder = false,
          git = false,
        }
      }
    },
    view = {
      cursorline = false,
      width = 30,
    },
    on_attach = require("user.nvim-tree-git-mv").on_attach,
  },
}
