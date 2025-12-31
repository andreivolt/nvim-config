return {
  "Olical/conjure",
  ft = {
    "clojure",
    "fennel",
    "janet",
    "python",
  },
  init = function()
    -- Let LSP handle K (hover) instead of Conjure
    vim.g["conjure#mapping#doc_word"] = ""
    -- Auto-start babashka REPL (dies with vim)
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = true
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#hidden"] = true
    vim.g["conjure#client#clojure#nrepl#connection#auto_repl#cmd"] = "bb nrepl-server localhost:0"
  end,
}
