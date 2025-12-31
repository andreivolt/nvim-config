vim.opt.guicursor = {
  'n-v-c-sm:block-Cursor',
  'i-ci-ve:ver25-Cursor',
  'r-cr-o:hor20-Cursor'
}

vim.api.nvim_create_autocmd('ModeChanged', {
  callback = function()
    local mode = vim.fn.mode()
    local color = ({
      n = '#ffffff', -- normal: white
      i = '#9ceb4f', -- insert: green (adding)
      v = '#31baff', -- visual: blue (selection)
      V = '#31baff', -- visual line: blue
      ['\22'] = '#31baff', -- visual block: blue
      c = '#ff9326', -- command: orange
      r = '#ff4040', -- replace: red (destructive)
      R = '#ff4040', -- replace: red
    })[mode]

    if not color then return end

    vim.api.nvim_set_hl(0, 'Cursor', { bg = color })
  end
})
