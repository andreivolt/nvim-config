-- OSC 52 clipboard for SSH.
--
-- OSC 52 *copy* works over a remote link (kitty honours it, tmux forwards it
-- with set-clipboard on). OSC 52 *paste* does NOT: it is a terminal read
-- query, and tmux never answers it -- so nvim hangs "waiting for OSC 52, press
-- Ctrl-C" on every paste. With clipboard=unnamedplus the unnamed register is
-- routed through `+`, so even a plain `p` or `:reg` triggers it.
--
-- Fix: keep OSC 52 for copy, but make paste return nvim's own register -- no
-- terminal round-trip, no hang. In a remote session you paste back what you
-- yanked anyway, and the yank already reached the real clipboard via the copy
-- side. (Trade-off: `"+p` pastes the last nvim yank, not the local machine's
-- clipboard -- which genuinely cannot be read back through tmux.)
if vim.env.SSH_TTY then
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste()
    return { vim.fn.getreg('"', 1, true), vim.fn.getregtype('"') }
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52.copy('+'),
      ['*'] = osc52.copy('*'),
    },
    paste = {
      ['+'] = paste,
      ['*'] = paste,
    },
  }
end
