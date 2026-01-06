return {
  'nvim-tree/nvim-tree.lua',
  dependencies =  'nvim-tree/nvim-web-devicons',
  keys = {
    { "<leader>n", "<cmd>NvimTreeFindFileToggle<cr>", desc = "tree" },
  },
  init = function()
    local border_fg = "#555566"

    local function set_tree_hl()
      vim.api.nvim_set_hl(0, "NvimTreeBorder", { fg = border_fg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeWinBar", { fg = border_fg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeStatusLine", { fg = border_fg, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "NONE", bg = "NONE" })
    end
    set_tree_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_tree_hl })

    vim.fn.sign_define("NvimTreeBorderSign", { text = "│", texthl = "NvimTreeBorder" })
    local ns_id = vim.api.nvim_create_namespace("NvimTreeBorders")

    -- Decoration provider for right border
    vim.api.nvim_set_decoration_provider(ns_id, {
      on_win = function(_, winid, bufnr, topline, botline)
        if vim.bo[bufnr].filetype ~= "NvimTree" then return false end

        local line_count = vim.api.nvim_buf_line_count(bufnr)
        for i = topline, math.min(botline, line_count - 1) do
          vim.api.nvim_buf_set_extmark(bufnr, ns_id, i, 0, {
            virt_text = { { "│", "NvimTreeBorder" } },
            virt_text_pos = "right_align",
            ephemeral = true,
          })
        end
        return false
      end,
    })

    local function update_tree_borders()
      local bufnr = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].filetype == "NvimTree" then
          bufnr = buf
          break
        end
      end
      if not bufnr then return end

      vim.fn.sign_unplace("NvimTreeBorderGroup", { buffer = bufnr })
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      for i = 1, line_count do
        vim.fn.sign_place(0, "NvimTreeBorderGroup", "NvimTreeBorderSign", bufnr, { lnum = i })
      end
    end

    vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "WinEnter" }, {
      callback = function()
        if vim.bo.filetype == "NvimTree" then
          vim.schedule(function()
            local width = 30
            local h_line = string.rep("─", width - 2)

            vim.wo.winbar = "%#NvimTreeWinBar#╭" .. h_line .. "╮"
            vim.wo.statusline = "%#NvimTreeStatusLine#╰" .. h_line .. "╯"
            vim.wo.signcolumn = "yes:1"
            vim.wo.winhighlight = "WinSeparator:NvimTreeWinSeparator"
            vim.opt_local.fillchars:append({ vert = " " })
            update_tree_borders()
          end)
        else
          -- Reset if window had tree borders but now has different buffer
          local sl = vim.wo.statusline
          if sl and sl:match("NvimTreeStatusLine") then
            vim.wo.statusline = ""
            vim.wo.winbar = ""
          end
        end
      end,
    })

    -- Monkey-patch nvim-tree renderer to pad buffer with empty lines
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      once = true,
      callback = function()
        local Renderer = require("nvim-tree.renderer")
        local view = require("nvim-tree.view")
        local original_draw = Renderer.draw

        Renderer.draw = function(self)
          original_draw(self)

          local bufnr = view.get_bufnr()
          local winnr = view.get_winnr()
          if not bufnr or not winnr then return end

          local win_height = vim.api.nvim_win_get_height(winnr)
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          local padding_needed = win_height - line_count

          if padding_needed > 0 then
            vim.bo[bufnr].modifiable = true
            local empty_lines = {}
            for _ = 1, padding_needed do
              table.insert(empty_lines, "")
            end
            vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, empty_lines)
            vim.bo[bufnr].modifiable = false
          end

          update_tree_borders()
        end
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
      indent_markers = {
        enable = true,
        icons = {
          corner = "└ ",
          edge = "│ ",
          item = "│ ",
          bottom = "─ ",
          none = "  ",
        },
      },
      icons = {
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
