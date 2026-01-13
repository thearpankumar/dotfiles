vim.g.mapleader = " "

vim.keymap.set('n', '<C-s>', ':w<CR>')      -- Save file with Ctrl+S
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>a') -- Save file with Ctrl+S in insert mode
vim.keymap.set('n', '<C-z>', 'u')           -- Undo with Ctrl+Z
vim.keymap.set('n', '<Leader>z', '<C-r>')   -- Redo with leader + z
vim.keymap.set('v', '<S-c>', '"+y')


vim.keymap.set('t', '<C-j>', vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true))

-- Ensure Dockerfile filetype detection
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {"Dockerfile", "*.dockerfile", "Dockerfile.*", "*.Dockerfile"},
    callback = function()
        vim.bo.filetype = "dockerfile"
    end,
})

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