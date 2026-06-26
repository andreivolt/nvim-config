-- Incremental selection by treesitter node. The nvim-treesitter main-branch
-- rewrite removed the nvim-treesitter.incremental_selection module, so this
-- reimplements it on top of the native vim.treesitter API: init selects the
-- node under the cursor, increment walks up to the next strictly larger
-- ancestor, decrement pops back down the remembered stack.
local M = {}

-- Per-buffer stack of selected nodes (most recent on top).
local selections = {}

local function node_range(node)
  local sr, sc, er, ec = node:range()
  return { sr, sc, er, ec }
end

local function ranges_equal(a, b)
  return a[1] == b[1] and a[2] == b[2] and a[3] == b[3] and a[4] == b[4]
end

-- Visually select a node's range as a charwise selection. Treesitter ranges are
-- 0-indexed with an exclusive end column; this mirrors the conversion the old
-- ts_utils.get_vim_range did to land on inclusive 1-indexed cursor positions.
local function select_node(buf, node)
  local sr, sc, er, ec = node:range()
  sr, sc, er = sr + 1, sc + 1, er + 1
  if ec == 0 then
    er = er - 1
    ec = math.max(#(vim.api.nvim_buf_get_lines(buf, er - 1, er, false)[1] or ""), 1)
  end
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd("normal! \27")
  end
  vim.fn.setpos(".", { buf, sr, sc, 0 })
  vim.cmd("normal! v")
  vim.fn.setpos(".", { buf, er, ec, 0 })
end

function M.init_selection()
  local buf = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node()
  if not node then return end
  selections[buf] = { node }
  select_node(buf, node)
end

function M.node_incremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = selections[buf]
  if not stack or #stack == 0 then
    return M.init_selection()
  end
  local cur = stack[#stack]
  local cur_range = node_range(cur)
  local parent = cur:parent()
  while parent and ranges_equal(node_range(parent), cur_range) do
    parent = parent:parent()
  end
  if parent then
    table.insert(stack, parent)
    select_node(buf, parent)
  else
    select_node(buf, cur)
  end
end

function M.node_decremental()
  local buf = vim.api.nvim_get_current_buf()
  local stack = selections[buf]
  if not stack or #stack <= 1 then return end
  table.remove(stack)
  select_node(buf, stack[#stack])
end

return M
