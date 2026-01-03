require("user.performance")

vim.deprecate = function() end

require("user.clipboard_osc52")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.treesitter.language.register('bash', 'zsh')

-- vim.opt.belloff = ""
-- vim.opt.errorbells = true
-- vim.opt.winblend = 25
vim.opt.winborder = "single"
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdwinheight = 10
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.confirm = true
vim.opt.guifont = "Pragmasevka Nerd Font Light:h14:w-2:#h-none"
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.laststatus = 2
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = { nbsp = '␣', tab = '» ', trail = '·' }
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend" -- disable right-click popup menu
vim.opt.path:append({ "**" })
vim.opt.pumblend = 25
vim.opt.pumheight = 10
vim.opt.ruler = false
vim.opt.scrolloff = 10
vim.opt.smoothscroll = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.shortmess:append({ I = true })
-- vim.opt.showbreak = "↳ "
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spelloptions = 'camel'
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.tags:prepend({ "./tags;" })
vim.opt.tags:remove({ "./tags", "./tags;" })
vim.opt.termguicolors = true
vim.opt.title = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "longest:full,full"
vim.opt.jumpoptions = { "stack", "view", "clean" }

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
})

require("user.highlight_on_yank")
require("user.paste_strip_whitespace")
require("user.auto_equalize_windows")
require("user.auto_reload")
require("user.auto_create_dir")
require("user.restore_cursor_location")


require("user.globals")
require("user.plugins")

require("user.colorscheme")
require("user.fold")
require("user.prose")

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    if vim.env.TMUX then require("user.tmux") end
    if vim.g.neovide then require("user.neovide") end
    require("user.cursorline")
    require("user.keymaps")
    require("user.no_scroll_at_eof")
  end,
})

require("user.search")
require("user.clear_echo")
