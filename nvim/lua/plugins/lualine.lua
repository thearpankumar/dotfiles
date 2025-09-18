return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup({
            options = {
                theme = 'auto' -- This will use your Catppuccin mint green colors
            }
        })
    end
}
