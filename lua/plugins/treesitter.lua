return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
  },
  event = { "BufReadPost", "BufNewFile" },
  cmd = {
    "TSInstall",
    "TSInstallFromGrammar",
    "TSLog",
    "TSUninstall",
    "TSUpdate",
  },
  build = ":TSUpdate",
  config = function()
    local ts = require("nvim-treesitter")
    ts.setup()

    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    -- The main-branch rewrite dropped the module system: highlight, indent and
    -- parser auto-install are no longer a config table but wired up per buffer.
    -- This reproduces the old highlight=on / indent=on / auto_install behaviour
    -- through a FileType hook, installing a missing parser asynchronously and
    -- enabling once it lands.
    local available = {}
    for _, lang in ipairs(ts.get_available()) do available[lang] = true end
    local installed = {}
    for _, lang in ipairs(ts.get_installed()) do installed[lang] = true end
    local has_cli = vim.fn.executable("tree-sitter") == 1
    local incremental = require("user.treesitter_incremental")

    local function start(buf)
      pcall(vim.treesitter.start, buf)
      vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.keymap.set("n", "<cr>", incremental.init_selection,
        { buffer = buf, desc = "init treesitter selection" })
    end

    local function process(buf)
      if not vim.api.nvim_buf_is_valid(buf) then return end
      local ft = vim.bo[buf].filetype
      local lang = vim.treesitter.language.get_lang(ft) or ft
      if lang == "" or not available[lang] then return end
      if installed[lang] then
        start(buf)
      elseif has_cli then
        ts.install(lang):await(vim.schedule_wrap(function(err)
          if err then return end
          installed[lang] = true
          if vim.api.nvim_buf_is_valid(buf) then start(buf) end
        end))
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
      callback = function(ev) process(ev.buf) end,
    })
    -- FileType for the buffer that triggered loading may already have fired.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then process(buf) end
    end

    -- Textobjects, formerly the configs `textobjects` table, are now plain
    -- keymaps over the rewritten textobjects API.
    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")
    local swap = require("nvim-treesitter-textobjects.swap")

    local function map_select(lhs, query, desc)
      vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(query, "textobjects") end, { desc = desc })
    end
    map_select("ak", "@block.outer", "around block")
    map_select("ik", "@block.inner", "inside block")
    map_select("ac", "@class.outer", "around class")
    map_select("ic", "@class.inner", "inside class")
    map_select("a?", "@conditional.outer", "around conditional")
    map_select("i?", "@conditional.inner", "inside conditional")
    map_select("af", "@function.outer", "around function")
    map_select("if", "@function.inner", "inside function")
    map_select("ao", "@loop.outer", "around loop")
    map_select("io", "@loop.inner", "inside loop")
    map_select("aa", "@parameter.outer", "around argument")
    map_select("ia", "@parameter.inner", "inside argument")

    local function map_move(lhs, fn, query, desc)
      vim.keymap.set({ "n", "x", "o" }, lhs, function() move[fn](query, "textobjects") end, { desc = desc })
    end
    map_move("]k", "goto_next_start", "@block.outer", "Next block start")
    map_move("]f", "goto_next_start", "@function.outer", "Next function start")
    map_move("]a", "goto_next_start", "@parameter.inner", "Next argument start")
    map_move("]K", "goto_next_end", "@block.outer", "Next block end")
    map_move("]F", "goto_next_end", "@function.outer", "Next function end")
    map_move("]A", "goto_next_end", "@parameter.inner", "Next argument end")
    map_move("[k", "goto_previous_start", "@block.outer", "Previous block start")
    map_move("[f", "goto_previous_start", "@function.outer", "Previous function start")
    map_move("[a", "goto_previous_start", "@parameter.inner", "Previous argument start")
    map_move("[K", "goto_previous_end", "@block.outer", "Previous block end")
    map_move("[F", "goto_previous_end", "@function.outer", "Previous function end")
    map_move("[A", "goto_previous_end", "@parameter.inner", "Previous argument end")

    local function map_swap(lhs, fn, query, desc)
      vim.keymap.set("n", lhs, function() swap[fn](query) end, { desc = desc })
    end
    map_swap(">K", "swap_next", "@block.outer", "Swap next block")
    map_swap(">F", "swap_next", "@function.outer", "Swap next function")
    map_swap(">A", "swap_next", "@parameter.inner", "Swap next argument")
    map_swap("<K", "swap_previous", "@block.outer", "Swap previous block")
    map_swap("<F", "swap_previous", "@function.outer", "Swap previous function")
    map_swap("<A", "swap_previous", "@parameter.inner", "Swap previous argument")
  end,
}
