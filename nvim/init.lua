vim.g.mapleader = " "

vim.keymap.set('n', '<Leader>s', ':w<CR>')  -- Save file with leader + s
vim.keymap.set('n', '<C-z>', 'u')           -- Undo with Ctrl+Z
vim.keymap.set('n', '<Leader>z', '<C-r>')   -- Redo with leader + z

vim.keymap.set('t', '<C-j>', vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true))

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("vim-options")