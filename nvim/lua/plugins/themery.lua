return {
    -- Theme plugins
    {
        "folke/tokyonight.nvim",
        lazy = true,
        opts = { style = "storm" },
    },
    {
        "Zeioth/neon.nvim",
        lazy = true,
    },
    {
        "rebelot/kanagawa.nvim",
        lazy = true,
    },
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
    },
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
    {
        "EdenEast/nightfox.nvim",
        lazy = true,
    },

    -- Theme switcher
    {
        "zaldih/themery.nvim",
        lazy = false,
        config = function()
            require("themery").setup({
                livePreview = true,
                themes = {
                    -- ── Your Custom Theme ──────────────────────────────────────
                    {
                        name = "My Darcula (Custom)",
                        colorscheme = "catppuccin",
                    },

                    -- ── Tokyonight ─────────────────────────────────────────────
                    {
                        name = "Tokyonight Storm",
                        colorscheme = "tokyonight-storm",
                    },
                    {
                        name = "Tokyonight Night",
                        colorscheme = "tokyonight-night",
                    },
                    {
                        name = "Tokyonight Moon",
                        colorscheme = "tokyonight-moon",
                    },
                    {
                        name = "Tokyonight Day",
                        colorscheme = "tokyonight-day",
                    },

                    -- ── Cyberpunk ──────────────────────────────────────────────
                    {
                        name = "Neon (Cyberpunk)",
                        colorscheme = "neon",
                    },

                    -- ── Kanagawa ───────────────────────────────────────────────
                    {
                        name = "Kanagawa Wave",
                        colorscheme = "kanagawa-wave",
                    },
                    {
                        name = "Kanagawa Dragon",
                        colorscheme = "kanagawa-dragon",
                    },
                    {
                        name = "Kanagawa Lotus",
                        colorscheme = "kanagawa-lotus",
                    },

                    -- ── Gruvbox ────────────────────────────────────────────────
                    {
                        name = "Gruvbox Dark",
                        colorscheme = "gruvbox",
                        before = [[vim.opt.background = "dark"]],
                    },
                    {
                        name = "Gruvbox Light",
                        colorscheme = "gruvbox",
                        before = [[vim.opt.background = "light"]],
                    },

                    -- ── Rose Pine ──────────────────────────────────────────────
                    {
                        name = "Rose Pine",
                        colorscheme = "rose-pine",
                    },
                    {
                        name = "Rose Pine Moon",
                        colorscheme = "rose-pine-moon",
                    },
                    {
                        name = "Rose Pine Dawn",
                        colorscheme = "rose-pine-dawn",
                    },

                    -- ── Nightfox ───────────────────────────────────────────────
                    {
                        name = "Nightfox",
                        colorscheme = "nightfox",
                    },
                    {
                        name = "Carbonfox",
                        colorscheme = "carbonfox",
                    },
                    {
                        name = "Duskfox",
                        colorscheme = "duskfox",
                    },
                    {
                        name = "Dayfox",
                        colorscheme = "dayfox",
                    },
                },
            })

            vim.keymap.set("n", "<leader>dh", ":Themery<CR>", { desc = "Theme switcher" })
        end,
    },
}
