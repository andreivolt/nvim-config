-- init.lua enables 'title', but Neovim never restores the terminal title on
-- exit, so under tmux the pane title (#T) lingers as the last edited file. tmux
-- and xterm-like terminals support the title stack, so push the current title
-- now -- which must happen before 'title' is enabled, hence requiring this early
-- -- and pop it back on VimLeave. Guarded to a real terminal so headless and
-- GUI (neovide) runs don't get stray escapes written to stdout.
if vim.fn.has("ttyout") == 1 then
  io.write("\27[22;2t")
  io.flush()
  vim.api.nvim_create_autocmd("VimLeave", {
    callback = function()
      io.write("\27[23;2t")
      io.flush()
    end,
  })
end
