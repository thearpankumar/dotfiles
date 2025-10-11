return {
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        event = "VeryLazy",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            -- Just ensure servers are installed, don't auto-configure
            require("mason-lspconfig").setup({
                ensure_installed = {"lua_ls", "clangd", "cmake", "cssls", "html", "rust_analyzer", "pyright"},
                automatic_installation = true,
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        config = function()
            -- Use Neovim 0.11+ native LSP API
            -- nvim-lspconfig provides default configs, we just customize what we need

            -- Customize rust_analyzer for better performance
            vim.lsp.config('rust_analyzer', {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = { allFeatures = true },
                        checkOnSave = { command = "check" },  -- Use 'check' instead of 'clippy' for speed
                        procMacro = { enable = true },
                        diagnostics = { enable = true, experimental = { enable = false } },
                    }
                }
            })

            -- Customize pyright
            vim.lsp.config('pyright', {
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        }
                    }
                }
            })

            -- Enable all LSP servers (uses configs from nvim-lspconfig automatically)
            vim.lsp.enable({ 'lua_ls', 'rust_analyzer', 'pyright', 'clangd', 'cmake', 'cssls', 'html' })

            -- LSP keybindings
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP hover' })
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP go to definition' })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'LSP references' })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP code action' })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'LSP rename' })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
            vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
        end
    }
}
