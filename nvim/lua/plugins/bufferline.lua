return {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                separator_style = "slant",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                color_icons = true,
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        text_align = "center",
                        separator = true
                    }
                }
            },
            -- Teal blue highlights
            highlights = {
                buffer_selected = {
                    fg = '#00FFFF', -- Teal blue for selected buffer
                    bold = true,
                },
                indicator_selected = {
                    fg = '#00FFFF', -- Teal blue for indicator
                },
                separator_selected = {
                    fg = '#00FFFF', -- Teal blue for separator
                },
                close_button_selected = {
                    fg = '#00FFFF', -- Teal blue for close button
                },
                tab_selected = {
                    fg = '#00FFFF', -- Teal blue for selected tab
                },
            },
        })

        -- Key mappings for tab navigation
        vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { silent = true })
        vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { silent = true })
        vim.keymap.set('n', '<leader>x', ':BufferLinePickClose<CR>', { silent = true })
        vim.keymap.set('n', '<leader>c', ':bdelete<CR>', { silent = true })
        vim.keymap.set('n', '<leader>co', ':BufferLineCloseOthers<CR>', { silent = true })
        vim.keymap.set('n', '<leader>cr', ':BufferLineCloseRight<CR>', { silent = true })
        vim.keymap.set('n', '<leader>cl', ':BufferLineCloseLeft<CR>', { silent = true })
    end
}

