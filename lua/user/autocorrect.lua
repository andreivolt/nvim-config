local languages = { "English", "French", "Romanian" }
local enabled = true
local debounce_ms = 150
local highlight_ms = 2000
local min_words = 3
local max_length_ratio = 1.3
local ns = vim.api.nvim_create_namespace("autocorrect")

local system_prompt = "Determine which language ("
  .. table.concat(languages, ", ")
  .. ") the text is written in, then fix only misspelled words according to that language's spelling rules. "
  .. "Preserve everything else exactly — grammar, punctuation, capitalization, spacing, line structure. "
  .. "Return only the corrected text, nothing else."

-- Dirty set + drain loop architecture
-- Each tracked line gets an extmark (stable across inserts/deletes) and a generation counter.
-- Events mark lines dirty (bump generation). A scheduler drains one dirty line at a time.

local buf_state = {} -- { [bufnr] = state }

local function get_state(bufnr)
  if not buf_state[bufnr] then
    buf_state[bufnr] = {
      marks = {},        -- { [extmark_id] = { gen = N, processed_gen = N } }
      row_to_mark = {},  -- { [row_0indexed] = extmark_id } — for fast lookup
      pending = nil,     -- { mark_id, handle, content, gen } — single in-flight request
      timer = nil,
      last_row = nil,
    }
  end
  return buf_state[bufnr]
end

local function get_or_create_mark(bufnr, row_1indexed)
  local state = get_state(bufnr)
  local row_0 = row_1indexed - 1
  local mark_id = state.row_to_mark[row_0]
  if mark_id then
    -- Verify extmark still at expected row
    local pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, mark_id, {})
    if pos and pos[1] == row_0 then
      return mark_id
    end
    -- Extmark moved — look up by new position or clear stale entry
    state.row_to_mark[row_0] = nil
  end

  -- Check if there's already a mark at this row (extmark may have shifted here)
  local existing = vim.api.nvim_buf_get_extmarks(bufnr, ns, { row_0, 0 }, { row_0, 0 }, {})
  for _, ext in ipairs(existing) do
    if state.marks[ext[1]] then
      state.row_to_mark[row_0] = ext[1]
      return ext[1]
    end
  end

  -- Create new extmark
  mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns, row_0, 0, {})
  state.marks[mark_id] = { gen = 0, processed_gen = 0, force = false }
  state.row_to_mark[row_0] = mark_id
  return mark_id
end

local function mark_row(bufnr, mark_id)
  local pos = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns, mark_id, {})
  return pos and (pos[1] + 1) or nil
end

local function mark_dirty(bufnr, row_1indexed, opts)
  local mark_id = get_or_create_mark(bufnr, row_1indexed)
  local state = get_state(bufnr)
  local m = state.marks[mark_id]
  m.gen = m.gen + 1
  if opts and opts.force then
    m.force = true
  end
  return mark_id
end

local function is_dirty(state, mark_id)
  local m = state.marks[mark_id]
  return m and m.gen > m.processed_gen
end

-- Validation: reject hallucinated rewrites

local function skeleton(s)
  return s:gsub("%a+", "")
end

local function word_count(s)
  return select(2, s:gsub("%S+", ""))
end

local function validate(original, corrected)
  if corrected == original then return false end
  -- Length ratio
  if #original > 0 and #corrected / #original > max_length_ratio then return false end
  if #original > 0 and #original / #corrected > max_length_ratio then return false end
  -- Word count must match
  if word_count(original) ~= word_count(corrected) then return false end
  -- Non-alphabetic skeleton must match (preserves markdown syntax, punctuation structure)
  if skeleton(original) ~= skeleton(corrected) then return false end
  -- Leading whitespace must match
  local orig_indent = original:match("^%s*")
  local corr_indent = corrected:match("^%s*")
  if orig_indent ~= corr_indent then return false end
  return true
end

-- Treesitter: skip code blocks in markdown

local function in_code_block(bufnr, row_0)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok or not parser then return false end
  local trees = parser:parse()
  if not trees or not trees[1] then return false end
  local root = trees[1]:root()
  local node = root:named_descendant_for_range(row_0, 0, row_0, 0)
  while node do
    local t = node:type()
    if t == "fenced_code_block" or t == "code_fence_content" or t == "code_span" or t == "code_block" then
      return true
    end
    node = node:parent()
  end
  return false
end

-- Highlight changed words

local function highlight_diff(bufnr, row, old, new)
  local old_words = {}
  for word in old:gmatch("%S+") do
    old_words[#old_words + 1] = word
  end
  local idx = 0
  for pos, word in new:gmatch("()(%S+)") do
    idx = idx + 1
    if word ~= old_words[idx] then
      vim.api.nvim_buf_set_extmark(bufnr, ns, row - 1, pos - 1, {
        end_col = pos - 1 + #word,
        hl_group = "IncSearch",
        priority = 1000,
      })
    end
  end
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      -- Clear only highlight extmarks (those with hl_group), not row-tracking extmarks
      local marks = vim.api.nvim_buf_get_extmarks(bufnr, ns, { row - 1, 0 }, { row - 1, -1 }, { details = true })
      for _, m in ipairs(marks) do
        if m[4] and m[4].hl_group then
          vim.api.nvim_buf_del_extmark(bufnr, ns, m[1])
        end
      end
    end
  end, highlight_ms)
end

-- Forward declaration
local drain

-- API call

local function send_request(bufnr, mark_id, state)
  local row = mark_row(bufnr, mark_id)
  if not row then return end

  local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
  if not line or line:match("^%s*$") then return end
  if in_code_block(bufnr, row - 1) then return end

  local api_key = vim.env.OPENROUTER_KEY
  if not api_key then return end

  local gen = state.marks[mark_id].gen
  local trailing = line:match("%s+$") or ""
  local trimmed = line:sub(1, #line - #trailing)

  -- Strip last incomplete word only if line doesn't end with space/punct
  local suffix = ""
  local to_check = trimmed
  if trailing == "" and trimmed ~= "" and not trimmed:match("%p$") then
    local last_space = trimmed:match(".*()%s")
    if last_space then
      to_check = trimmed:sub(1, last_space)
      suffix = trimmed:sub(last_space + 1)
    else
      return  -- Single incomplete word, nothing to check
    end
  end
  if to_check:match("^%s*$") then return end

  local body = vim.json.encode({
    model = "anthropic/claude-haiku-4.5",
    max_tokens = 256,
    temperature = 0,
    messages = {
      { role = "system", content = system_prompt },
      { role = "user", content = to_check },
    },
  })

  state.pending = {
    mark_id = mark_id,
    gen = gen,
    content = line,
    handle = vim.system(
      {
        "curl", "-s",
        "https://openrouter.ai/api/v1/chat/completions",
        "-H", "Content-Type: application/json",
        "-H", "Authorization: Bearer " .. api_key,
        "-d", body,
      },
      { text = true },
      function(result)
        vim.schedule(function()
          local st = get_state(bufnr)
          st.pending = nil

          if result.code ~= 0 or not result.stdout or result.stdout == "" then
            drain(bufnr)
            return
          end

          local ok, decoded = pcall(vim.json.decode, result.stdout)
          if not ok or not decoded.choices or not decoded.choices[1] then
            drain(bufnr)
            return
          end

          local corrected = decoded.choices[1].message.content
          if not corrected or corrected == "" then
            drain(bufnr)
            return
          end
          corrected = corrected:match("^[^\n]*"):gsub("%s+$", "")
          if suffix ~= "" then
            corrected = corrected .. " " .. suffix
          end
          corrected = corrected .. trailing

          if not vim.api.nvim_buf_is_valid(bufnr) then return end

          local m = st.marks[mark_id]
          if not m then
            drain(bufnr)
            return
          end

          -- Mark as processed regardless of whether we apply (avoids re-sending same content)
          m.processed_gen = m.gen
          m.force = false

          if corrected == line then
            drain(bufnr)
            return
          end

          if not validate(line, corrected) then
            drain(bufnr)
            return
          end

          -- Verify line unchanged
          local current_row = mark_row(bufnr, mark_id)
          if not current_row then
            drain(bufnr)
            return
          end
          local current = vim.api.nvim_buf_get_lines(bufnr, current_row - 1, current_row, false)[1]
          if current ~= line then
            -- Line changed while request was in flight; TextChangedI already scheduled next check
            return
          end

          local cur = vim.api.nvim_win_get_cursor(0)
          local offset_from_end = cur[1] == current_row and (#line - cur[2]) or nil

          pcall(vim.cmd, "undojoin")
          vim.api.nvim_buf_set_text(bufnr, current_row - 1, 0, current_row - 1, #line, { corrected })
          highlight_diff(bufnr, current_row, line, corrected)

          if offset_from_end then
            pcall(vim.api.nvim_win_set_cursor, 0, { current_row, math.max(0, #corrected - offset_from_end) })
          end

          drain(bufnr)
        end)
      end
    ),
  }
end

-- Drain loop: pick highest-priority dirty line, send one request
-- Priority: forced lines first, then farthest from cursor

drain = function(bufnr, target_mark_id)
  local state = get_state(bufnr)
  if not enabled or not vim.b[bufnr].autocorrect then return end
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  -- If a specific target was requested, cancel any in-flight request for a different line
  if target_mark_id and state.pending and state.pending.mark_id ~= target_mark_id then
    pcall(state.pending.handle.kill, state.pending.handle, 9)
    state.pending = nil
  end

  if state.pending then return end

  -- If a specific target was requested and it's valid, use it
  if target_mark_id then
    local m = state.marks[target_mark_id]
    if m and is_dirty(state, target_mark_id) then
      local row = mark_row(bufnr, target_mark_id)
      if row then
        local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
        if line and not line:match("^%s*$") and (m.force or word_count(line) >= min_words) then
          send_request(bufnr, target_mark_id, state)
          return
        end
      end
    end
  end

  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local best_mark, best_score = nil, -1

  for mark_id, m in pairs(state.marks) do
    if is_dirty(state, mark_id) then
      local row = mark_row(bufnr, mark_id)
      if row then
        local line = vim.api.nvim_buf_get_lines(bufnr, row - 1, row, false)[1]
        local skip_min_words = m.force
        if line and not line:match("^%s*$") and (skip_min_words or word_count(line) >= min_words) then
          -- Score: forced lines get +1000, then add distance from cursor
          local score = (m.force and 1000 or 0) + math.abs(row - cursor_row)
          if score > best_score then
            best_mark = mark_id
            best_score = score
          end
        end
      end
    end
  end

  if best_mark then
    send_request(bufnr, best_mark, state)
  end
end

-- Schedule drain with debounce

local function schedule_drain(bufnr, delay)
  if not enabled or not vim.b[bufnr].autocorrect then return end
  local state = get_state(bufnr)
  if state.timer then return end  -- Don't reset; let existing timer fire
  state.timer = vim.defer_fn(function()
    state.timer = nil
    drain(bufnr)
  end, delay or debounce_ms)
end

-- Events

local group = vim.api.nvim_create_augroup("UserAutocorrect", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "text", "markdown" },
  callback = function(ev)
    vim.b[ev.buf].autocorrect = true
  end,
})

vim.api.nvim_create_autocmd("TextChangedI", {
  group = group,
  callback = function(ev)
    if not enabled or not vim.b[ev.buf].autocorrect then return end
    local bufnr = ev.buf
    local state = get_state(bufnr)
    local row = vim.api.nvim_win_get_cursor(0)[1]

    -- Line change (Enter pressed) → mark previous dirty with force and drain immediately
    if state.last_row and state.last_row ~= row then
      local mid = mark_dirty(bufnr, state.last_row, { force = true })
      drain(bufnr, mid)
    end
    state.last_row = row

    -- Mark current line dirty on every change, debounce handles throttling
    mark_dirty(bufnr, row)
    schedule_drain(bufnr)
  end,
})

vim.api.nvim_create_autocmd("CursorHoldI", {
  group = group,
  callback = function(ev)
    if not enabled or not vim.b[ev.buf].autocorrect then return end
    local mid = mark_dirty(ev.buf, vim.api.nvim_win_get_cursor(0)[1], { force = true })
    drain(ev.buf, mid)
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = group,
  callback = function(ev)
    if not enabled or not vim.b[ev.buf].autocorrect then return end
    local state = get_state(ev.buf)
    if state.timer then
      state.timer:stop()
      state.timer = nil
    end
    local mid = mark_dirty(ev.buf, vim.api.nvim_win_get_cursor(0)[1], { force = true })
    drain(ev.buf, mid)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  group = group,
  callback = function(ev)
    local state = buf_state[ev.buf]
    if state then
      if state.pending then
        pcall(state.pending.handle.kill, state.pending.handle, 9)
      end
      if state.timer then state.timer:stop() end
    end
    buf_state[ev.buf] = nil
  end,
})

-- Commands

vim.api.nvim_create_user_command("AutocorrectOn", function()
  enabled = true
  vim.notify("Autocorrect enabled")
end, {})

vim.api.nvim_create_user_command("AutocorrectOff", function()
  enabled = false
  vim.notify("Autocorrect disabled")
end, {})

vim.api.nvim_create_user_command("AutocorrectToggle", function()
  enabled = not enabled
  vim.notify("Autocorrect " .. (enabled and "enabled" or "disabled"))
end, {})

return { toggle = function() vim.cmd("AutocorrectToggle") end }
