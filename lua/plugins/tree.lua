return {
  'nvim-tree/nvim-tree.lua',
  dependencies =  'nvim-tree/nvim-web-devicons',
  keys = {
    {"<leader>n", "<cmd>NvimTreeFindFileToggle<cr>"},
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
    local ns = vim.api.nvim_create_namespace("nvimtree_hl")
    local tree_bg = "#111111"
    vim.api.nvim_set_hl(ns, "Normal", { bg = tree_bg })
    vim.api.nvim_set_hl(ns, "WinBar", { bg = tree_bg })
    vim.api.nvim_set_hl(ns, "WinBarNC", { bg = tree_bg })
    vim.api.nvim_set_hl(ns, "EndOfBuffer", { fg = tree_bg, bg = tree_bg })
    vim.api.nvim_set_hl(ns, "WinSeparator", { fg = tree_bg, bg = tree_bg })
    vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { bg = tree_bg })
    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "NvimTree_*",
      callback = function()
        vim.api.nvim_win_set_hl_ns(0, ns)
        vim.wo.statusline = "%#NvimTreeStatusLine#"
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
        },
        glyphs = {
          folder = {
            arrow_closed = "⏵",
            arrow_open = "⏷",
          },
        },
      }
    },
    view = {
      cursorline = false,
      width = 30,
    },
    actions = {
      open_file = {
        window_picker = {
          enable = false,
        },
      },
    },
    on_attach = require("user.nvim-tree-git-mv").on_attach,
  },
}
