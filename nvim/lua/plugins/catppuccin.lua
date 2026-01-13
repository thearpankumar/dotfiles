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
                    blue = "#00FFFF",     -- Teal blue for primary accents
                    lavender = "#00FFFF", -- Teal blue for lavender
                    sapphire = "#00FFFF", -- Teal blue for sapphire
                    sky = "#00FFFF",      -- Teal blue for sky
                    teal = "#777C6D",     -- Muted olive for secondary accents
                    green = "#B153D7",    -- Purple for green elements
                },
            },
        })
        vim.cmd.colorscheme "catppuccin"
    end
}
