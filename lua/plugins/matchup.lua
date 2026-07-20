return {
  "andymass/vim-matchup",
  init = function()
    -- vim-matchup's treesitter engine (treesitter-matchup) targets the old
    -- nvim-treesitter master API: it routes through nvim-treesitter.configs
    -- and query_predicates, neither of which exists on the main-branch
    -- rewrite, and the old code path blows up with E5108 on nvim 0.12.
    -- Disable the ts integration so matchup falls back to its regex engine.
    -- Must be false, not 0: treesitter-matchup checks it from Lua where 0 is
    -- truthy, so a numeric 0 would leave the ts engine enabled.
    vim.g.matchup_treesitter_enabled = false
    vim.g.matchup_matchparen_offscreen = { method = "popup" }
  end,
  event = "BufReadPost",
}
