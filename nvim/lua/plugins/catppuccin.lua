return {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            transparent_background = true,
            flavour = "mocha",
            color_overrides = {
                mocha = {
                    blue = "#ACECA1",     -- MINT GREEN instead of blue
                    lavender = "#ACECA1", -- MINT GREEN instead of lavender
                    sapphire = "#ACECA1", -- MINT GREEN instead of sapphire
                    sky = "#ACECA1",      -- MINT GREEN instead of sky blue
                    teal = "#ACECA1",     -- MINT GREEN instead of teal
                },
            },
        })
        vim.cmd.colorscheme "catppuccin"
    end
}
