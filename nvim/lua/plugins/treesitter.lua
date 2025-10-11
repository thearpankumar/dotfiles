return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            -- Install parsers for all common languages (stable parsers only)
            ensure_installed = {
                -- Core programming languages
                "c", "cpp", "rust", "go",
                "python", "java", "lua",
                "javascript", "typescript", "tsx",

                -- Web development
                "html", "css", "scss",
                "vue",

                -- Config & data formats
                "json", "yaml", "toml",
                "dockerfile", "make", "cmake",

                -- Shell & scripting
                "bash", "fish",

                -- Documentation
                "markdown", "markdown_inline",
                "comment", "regex",

                -- Version control
                "gitcommit", "gitignore",

                -- Other
                "vim", "vimdoc",
            },

            -- Sync install (blocking) - prevents partial installations
            sync_install = false,

            -- Don't auto-install parsers (install manually when needed)
            auto_install = false,

            highlight = {
                enable = true,
                -- Additional language support
                additional_vim_regex_highlighting = { "dockerfile" },
                -- Disable for very large files (performance)
                disable = function(lang, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },

            indent = { enable = true },

            -- Additional features
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    scope_incremental = "<TAB>",
                    node_decremental = "<S-TAB>",
                },
            },
        })
    end
}
