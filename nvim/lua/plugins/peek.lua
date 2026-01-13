return {
  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup({
        auto_load = true,         -- whether to automatically load preview when entering markdown buffer
        close_on_bdelete = true,  -- close preview window on buffer delete
        syntax = true,            -- enable syntax highlighting, affects performance
        theme = 'dark',           -- 'dark' or 'light'
        update_on_change = true,
        app = 'browser',          -- use browser instead of webview
        filetype = { 'markdown', 'md', 'mkd', 'mdwn', 'mdown', 'mdtxt', 'mdtext', 'rmd' }, -- expanded markdown filetypes
      })
      
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
      vim.api.nvim_create_user_command("PeekToggle", function()
        local peek = require("peek")
        if peek.is_open() then
          peek.close()
        else
          peek.open()
        end
      end, {})
      
      -- Keybindings
      vim.keymap.set('n', '<leader>cp', '<cmd>PeekToggle<cr>', { desc = "Peek Toggle" })
    end,
  },
}