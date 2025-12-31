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
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
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
      per_filetype = {
        -- gitcommit = { 'git', 'buffer' },
        -- markdown = { 'dictionary', 'buffer' },
        -- text = { 'dictionary', 'buffer' },
      },
      providers = {
        buffer = { min_keyword_length = 5 },
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
