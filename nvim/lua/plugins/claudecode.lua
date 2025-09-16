return {
    {
        "coder/claudecode.nvim",
        dependencies = { "folke/snacks.nvim" },
        config = function()
            require("claudecode").setup()
        end,
        keys = {
            { "<leader>f",  false },

            { "<leader>fc", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
            { "<leader>ff", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
            { "<leader>fr", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
            { "<leader>fC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
            { "<leader>fm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
            { "<leader>fb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
            { "<leader>fs", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
            {
                "<leader>fs",
                "<cmd>ClaudeCodeTreeAdd<cr>",
                desc = "Add file",
                ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
            },
            { "<leader>fa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
            { "<leader>fd", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },


        },
        cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeAdd" },
        event = "VeryLazy",
    },
}
