return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    rust = { "rustfmt" },
                    python = { "black", "isort" },
                    lua = { "stylua" },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
            })
            
            vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                require("conform").format({
                    lsp_fallback = true,
                    async = false,
                    timeout_ms = 500,
                })
            end, { desc = "Format file or range (in visual mode)" })
        end,
    },
    {
        "mhartington/formatter.nvim",
        config = function()
            require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
                filetype = {
                    rust = {
                        require("formatter.filetypes.rust").rustfmt,
                    },
                    python = {
                        require("formatter.filetypes.python").black,
                    },
                },
            })
        end,
    }
}