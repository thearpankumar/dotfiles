-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Markdown: read-only rendered view, no diagnostics (marksman LSP etc.) and no spell squiggles
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("markdown_clean_view", { clear = true }),
  pattern = { "markdown" },
  callback = function(ev)
    vim.diagnostic.enable(false, { bufnr = ev.buf })
    vim.opt_local.spell = false
  end,
})
