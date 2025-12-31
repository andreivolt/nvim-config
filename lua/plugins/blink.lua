return {
  'saghen/blink.cmp',
  version = '1.*',
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    'L3MON4D3/LuaSnip',
    -- 'Kaiser-Yang/blink-cmp-dictionary',
    -- 'Kaiser-Yang/blink-cmp-git',
  },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'none',
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        'select_next',
        'snippet_forward',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(TaboutMulti)', true, true, true), 'm', false)
        end,
      },
      ['<S-Tab>'] = {
        'select_prev',
        'snippet_backward',
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(TaboutBackMulti)', true, true, true), 'm', false)
        end,
      },
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-Space>'] = { 'show', 'fallback' },
    },

    snippets = { preset = 'luasnip' },

    completion = {
      ghost_text = { enabled = true },
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } },
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'buffer', 'snippets' },
      providers = {
        buffer = {
          min_keyword_length = 5,
          max_items = 5,
        },
      },
    },

    cmdline = {
      enabled = true,
      keymap = {
        preset = 'none',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },
    },
  },
}
