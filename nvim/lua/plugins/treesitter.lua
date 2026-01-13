return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            ensure_installed = {
                "c", "cpp", "rust", "go", "python", "java", "lua",
                "javascript", "typescript", "tsx", "html", "css", "scss", "vue",
                "json", "yaml", "toml", "dockerfile", "make", "cmake",
                "bash", "fish", "markdown", "markdown_inline", "comment", "regex",
                "gitcommit", "gitignore", "vim", "vimdoc",
            },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "dockerfile" },
            },
            indent = { enable = true },
        })
    end
}
