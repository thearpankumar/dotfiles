-- Disable markdownlint-cli2 diagnostics from the LazyVim markdown extra.
return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- opts table merge can't empty a list, so drop the key here
    opts.linters_by_ft.markdown = nil
  end,
}
