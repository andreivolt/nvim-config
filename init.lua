vim.deprecate = function() end

-- kitty-scrollback: minimal UI
if vim.env.KITTY_SCROLLBACK_NVIM then
  vim.opt.signcolumn = "no"
  vim.opt.statuscolumn = ""
  vim.opt.number = false
  vim.opt.relativenumber = false
  vim.opt.foldcolumn = "0"
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.laststatus = 0
end

require("user.performance")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.treesitter.language.register('bash', 'zsh')

-- vim.opt.belloff = ""
-- vim.opt.errorbells = true
-- vim.opt.winblend = 25
vim.opt.breakindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdwinheight = 10
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.confirm = true
vim.opt.guifont = "Pragmasevka Nerd Font Light:h14:w-2:#h-none"
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.laststatus = 0
vim.opt.lazyredraw = true
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

vim.diagnostic.config({
  virtual_text = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- Strip trailing whitespace on paste
local original_paste = vim.paste
vim.paste = function(lines, phase)
  if phase == -1 or phase == 1 then
    for i, line in ipairs(lines) do
      lines[i] = line:gsub('[ \t]+$', '')
    end
  end
  return original_paste(lines, phase)
end

local function paste_and_strip(after)
  return function()
    local register = vim.v.register
    if register == '"' then register = '+' end
    local content = vim.fn.getreg(register)
    local regtype = vim.fn.getregtype(register)
    local cleaned = content:gsub('[ \t]+([\r\n])', '%1'):gsub('[ \t]+$', '')
    local lines = vim.split(cleaned, '\n', { plain = true })
    local is_linewise = regtype:match('^V') or regtype == 'l'
    vim.api.nvim_put(lines, is_linewise and 'l' or 'c', after, true)
  end
end

vim.keymap.set("n", "p", paste_and_strip(true))
vim.keymap.set("n", "P", paste_and_strip(false))
vim.keymap.set("x", "p", paste_and_strip(true))
vim.keymap.set("x", "P", paste_and_strip(false))

vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    vim.cmd.wincmd("=")
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "silent! checktime",
})

-- checktime skips background buffers, causing false "modified" prompts on quit
vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    vim.cmd("silent! checktime")
  end,
})


require("user.globals")
require("user.plugins")

require("user.colorscheme")
require("user.fold")
require("user.debug_highlight")

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    if vim.env.TMUX then require("user.tmux") end
    if vim.g.neovide then require("user.neovide") end
    require("user.cursorline")
    require("user.keymaps")
    require("user.spell")
    require("user.text")
  end,
})

vim.keymap.set('c', '<Tab>', function()
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    return '<CR>/<C-r>/'
  else
    return '<C-z>'
  end
end, { expr = true })

vim.keymap.set('c', '<S-Tab>', function()
  if vim.fn.getcmdtype() == '/' or vim.fn.getcmdtype() == '?' then
    return '<CR>?<C-r>/'
  else
    return '<S-Tab>'
  end
end, { expr = true })

vim.o.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd('echo ""') -- Clear the message
    end, 1000)           -- Delay in milliseconds (2 seconds)
  end,
})

