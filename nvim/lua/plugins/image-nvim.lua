return {
    "3rd/image.nvim",
    enabled = false,  -- Disable for now - Alacritty doesn't support kitty graphics
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
    },
    opts = {
        backend = "ueberzug",  -- ueberzug, kitty, or terminal
        integrations = {
            markdown = {
                enabled = true,
                only_render_image_at_cursor = false,
            },
        },
        max_width = 100,
        max_height = 30,
        max_height_window_percentage = math.huge,
        max_width_window_percentage = math.huge,
        window_overlap_clear_enabled = true,
    },
}
