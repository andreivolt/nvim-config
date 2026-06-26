return {
  "RRethy/nvim-treesitter-endwise",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    local endwise = require("nvim-treesitter-endwise")
    -- main-branch entry point: it hooks FileType/BufUnload through native
    -- vim.treesitter rather than the removed nvim-treesitter module registry
    -- (the old require("nvim-treesitter.configs").setup{endwise=...} is gone).
    endwise.init()
    -- init() only catches future FileType events, so attach any buffer that is
    -- already open at load time.
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf)
        and endwise.is_supported(vim.treesitter.language.get_lang(vim.bo[buf].filetype)) then
        require("nvim-treesitter.endwise").attach(buf)
      end
    end
  end,
  event = { "BufReadPost", "BufNewFile" },
}
