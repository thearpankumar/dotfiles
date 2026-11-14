-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- All shortcuts from github.com/thearpankumar/dotfiles. Where one clashed with a
-- LazyVim default, the old shortcut wins (plugin-level overrides live in
-- lua/plugins/dotfiles.lua).
local map = vim.keymap.set

-- Editing
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save File" })
map("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save File" })
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<leader>z", "<C-r>", { desc = "Redo" })
map("v", "C", '"+y', { desc = "Copy to system clipboard" })
map("t", "<C-j>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Find (old telescope keys, now using LazyVim's picker)
map("n", "ff", function() Snacks.picker.files() end, { desc = "Find files" })
map("n", "fs", function() Snacks.picker.grep() end, { desc = "Live grep" })

-- Buffers (bufferline)
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
map("n", "<leader>x", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })
map("n", "<leader>c", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>co", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
map("n", "<leader>cr", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to the right" })
map("n", "<leader>cl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to the left" })

-- LSP / diagnostics
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename (LSP)" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map({ "n", "v" }, "<leader>mp", function() LazyVim.format({ force = true }) end, { desc = "Format file or range" })

-- Debugging
map("n", "<leader>b", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Open debug REPL" })

-- Themes: open Omarchy's theme switcher (was Themery), so Neovim follows the system theme.
map("n", "<leader>dh", function()
  vim.fn.jobstart({ "omarchy", "theme", "switcher" }, { detach = true })
end, { desc = "Theme switcher (Omarchy)" })
