return {
  "andymass/vim-matchup",
  init = function()
    -- vim-matchup's treesitter engine routes through nvim-treesitter's
    -- query_predicates, which on the archived master branch calls the
    -- pre-0.12 node API and blows up with E5108 ("attempt to call method
    -- 'range' (a nil value)") on every CursorMoved under nvim 0.12. Disable
    -- the ts integration so matchup falls back to its regex engine.
    -- Must be false, not 0: treesitter-matchup checks it from Lua where 0 is
    -- truthy, so a numeric 0 would leave the ts engine enabled.
    vim.g.matchup_treesitter_enabled = false
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
  event = "BufReadPost",
}
