return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>gv", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Diff vs main (PR view)" },
        { "<leader>gD", "<cmd>DiffviewOpen<CR>",                    desc = "Diff uncommitted" },
        { "<leader>gq", "<cmd>DiffviewClose<CR>",                   desc = "Close diffview" },
    },
    config = function()
        require("diffview").setup({
            view = {
                default = { layout = "diff2_horizontal" },
            },
        })
    end,
}
