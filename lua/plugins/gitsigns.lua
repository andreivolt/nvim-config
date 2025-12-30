return {
  "lewis6991/gitsigns.nvim",
  opts = {
    preview_config = {
      border = 'rounded',
    },
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local opts = { buffer = bufnr }

      -- Navigation
      vim.keymap.set('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.nav_hunk('next') end)
        return '<Ignore>'
      end, { buffer = bufnr, expr = true })

      vim.keymap.set('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.nav_hunk('prev') end)
        return '<Ignore>'
      end, { buffer = bufnr, expr = true })

      -- Actions
      vim.keymap.set('n', '<leader>hs', gs.stage_hunk, opts)
      vim.keymap.set('n', '<leader>hr', gs.reset_hunk, opts)
      vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, opts)
      vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, opts)
      vim.keymap.set('n', '<leader>hS', gs.stage_buffer, opts)
      vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, opts)
      vim.keymap.set('n', '<leader>hR', gs.reset_buffer, opts)
      vim.keymap.set('n', '<leader>hp', gs.preview_hunk, opts)
      vim.keymap.set('n', '<leader>hb', function() gs.blame_line({ full = true }) end, opts)
      vim.keymap.set('n', '<leader>hd', gs.diffthis, opts)
      vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, opts)

      -- Text object
      vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', opts)
    end
  },
  event = "VeryLazy",
}
