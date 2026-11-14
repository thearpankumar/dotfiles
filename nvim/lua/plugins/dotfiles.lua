-- Features and shortcuts from github.com/thearpankumar/dotfiles, applied on top of
-- LazyVim. Where an old shortcut clashed with a LazyVim default, the old one wins.
-- No colorscheme plugins here, so Omarchy theme switching keeps working.
return {
  -- Move between Neovim splits and tmux panes with the same <C-h/j/k/l>
  -- (pairs with the vim-tmux-navigator plugin in ~/.config/tmux/tmux.conf).
  {
    "christoomey/vim-tmux-navigator",
    cmd = { "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight", "TmuxNavigatePrevious" },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to Left Window/Pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to Lower Window/Pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to Upper Window/Pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to Right Window/Pane" },
    },
  },

  -- Free up the LazyVim picker keys the old shortcuts use (Claude on <leader>f..., Diffview, Neo-tree git).
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>ff", false },
      { "<leader>fr", false },
      { "<leader>fb", false },
      { "<leader>fc", false },
      { "<leader>gD", false },
      { "<leader>gs", false },
    },
  },

  -- Claude Code on the old <leader>f... keys (LazyVim's <leader>a... keys also still work).
  {
    "coder/claudecode.nvim",
    keys = {
      { "<leader>fc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>ff", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>fr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>fC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>fm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>fb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>fs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>fs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
      },
      { "<leader>fa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>fd", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- Neo-tree on the right, as before.
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>e", "<cmd>Neotree filesystem reveal right<cr>", desc = "Open Neo-tree" },
      { "<leader>t", "<cmd>Neotree toggle right<cr>", desc = "Toggle Neo-tree" },
      { "<leader>gs", "<cmd>Neotree git_status right<cr>", desc = "Git status tree" },
    },
  },

  -- Git diff/PR review view.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diff vs main (PR view)" },
      { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diff uncommitted" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
  },

  -- Debugger F-keys (LazyVim's <leader>d... debug keys still work too).
  {
    "mfussenegger/nvim-dap",
    optional = true,
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
    },
  },

  -- LSP: give <leader>cr / <leader>cl back to the buffer-closing shortcuts.
  -- (Rename moves to <leader>rn, as in the old config.)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers["*"] = opts.servers["*"] or {}
      local keys = opts.servers["*"].keys or {}
      vim.list_extend(keys, {
        { "<leader>cr", false },
        { "<leader>cl", false },
      })
      opts.servers["*"].keys = keys
    end,
  },

  -- Treesitter: ]c / [c go back to git hunks, as before (class jumps keep ]C / [C).
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    opts = function(_, opts)
      local keys = vim.tbl_get(opts, "move", "keys") or {}
      if keys.goto_next_start then keys.goto_next_start["]c"] = nil end
      if keys.goto_previous_start then keys.goto_previous_start["[c"] = nil end
    end,
  },

  -- Gitsigns: ]c / [c jump between changed hunks (LazyVim's ]h / [h still work).
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      local lazyvim_on_attach = opts.on_attach
      opts.on_attach = function(buffer)
        if lazyvim_on_attach then lazyvim_on_attach(buffer) end
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, { buffer = buffer, desc = "Next Hunk" })
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, { buffer = buffer, desc = "Prev Hunk" })
      end
    end,
  },

  -- Completion: Tab / Shift+Tab move through suggestions, then jump through snippets.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },

  -- Show the ":" command line in the middle of the screen.
  {
    "folke/noice.nvim",
    opts = {
      presets = { command_palette = false },
      views = {
        cmdline_popup = {
          position = { row = "50%", col = "50%" },
          size = { width = 60, height = "auto" },
        },
        cmdline_popupmenu = {
          relative = "editor",
          position = { row = "50%+3", col = "50%" },
          size = { width = 60, height = 10 },
        },
      },
    },
  },
}
