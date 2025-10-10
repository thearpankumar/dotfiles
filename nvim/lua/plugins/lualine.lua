return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto' -- This will use your Catppuccin mint green colors
            }
        })
    end
}
