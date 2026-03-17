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
        { '<leader>t', '<cmd>Neotree toggle right<CR>', desc = 'Toggle Neo-tree' },
    },
    config = function()
        require("neo-tree").setup({
            window = {
                position = "right",
            },
        })
    end
}
