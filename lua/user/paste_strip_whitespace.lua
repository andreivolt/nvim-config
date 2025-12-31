-- Strip trailing whitespace on paste (both vim.paste and p/P keymaps)

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
