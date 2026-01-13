return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto' -- This will use your Catppuccin teal and olive colors
            }
        })
    end
}
