-- Show images, LaTeX math and Mermaid diagrams inside Neovim.
-- Works in Ghostty (kitty graphics protocol), including inside tmux (allow-passthrough on).
vim.env.PUPPETEER_EXECUTABLE_PATH = vim.env.PUPPETEER_EXECUTABLE_PATH or "/usr/bin/chromium"

return {
  {
    "folke/snacks.nvim",
    opts = {
      image = { enabled = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "css", "latex", "scss", "svelte", "typst", "vue" } },
  },
}
