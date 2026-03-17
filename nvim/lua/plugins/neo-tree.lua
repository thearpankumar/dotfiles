return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
        { '<leader>e', '<cmd>Neotree filesystem reveal right<CR>', desc = 'Open Neo-tree' },
        { '<leader>t', '<cmd>Neotree toggle right<CR>',            desc = 'Toggle Neo-tree' },
        { '<leader>gs', '<cmd>Neotree git_status right<CR>',       desc = 'Git status tree' },
    },
    config = function()
        require("neo-tree").setup({
            window = {
                position = "right",
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                },
            },
            git_status = {
                window = { position = "right" },
                symbols = {
                    added     = "✚",
                    modified  = "",
                    deleted   = "✖",
                    renamed   = "󰁕",
                    untracked = "★",
                    ignored   = "◌",
                    unstaged  = "󰄱",
                    staged    = "",
                    conflict  = "",
                },
            },
        })
    end,
}
