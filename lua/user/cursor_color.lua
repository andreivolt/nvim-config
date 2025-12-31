vim.opt.guicursor = {
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-Cursor',
  'r-cr-o:hor20-Cursor'
}

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    local mode = vim.fn.mode()
    local color = ({
      n = '#cfcfdd', -- normal: aurora accent_6
      i = '#9ceb4f', -- insert: aurora green
      v = '#9d8cff', -- visual: aurora purple
      V = '#9d8cff', -- visual line: aurora purple
      ['\22'] = '#ff70ff', -- visual block: aurora pink
      c = '#ff9326', -- command: aurora orange
      r = '#ff4040', -- replace: aurora red
      R = '#ff4040', -- replace virtual: aurora red
      ['!'] = '#ff9326', -- shell: aurora orange
      t = '#18ffe0', -- terminal: aurora aqua
    })[mode]

    if not color then return end

    vim.api.nvim_set_hl(0, 'Cursor', { bg = color })
  end
})
