return {
  'kevinhwang91/nvim-ufo',
  dependencies = 'kevinhwang91/promise-async',
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
  end,
  opts = {
    -- open opening the buffer, close these fold kinds
    close_fold_kinds_for_ft = {
      default = { "comment" },
      json = { "array" },
    },
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
    fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      -- get trailing parens/brackets from last line
      local endLine = vim.api.nvim_buf_get_lines(0, endLnum - 1, endLnum, false)[1] or ''
      local closingChars = endLine:match('[%)%]%}]+%s*$') or ''
      local suffix = (' 󰁂 %d %s'):format(endLnum - lnum, closingChars)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, 'MoreMsg' })
      return newVirtText
    end
  },
  keys = {
    { 'zR',        function() require('ufo').openAllFolds() end,               desc = 'Open all folds' },
    { 'zM',        function() require('ufo').closeAllFolds() end,              desc = 'Close all folds' },
    { '<leader>v', function() require('ufo').peekFoldedLinesUnderCursor() end, desc = 'Peek folded lines' },
  },
  event = "VeryLazy",
}
