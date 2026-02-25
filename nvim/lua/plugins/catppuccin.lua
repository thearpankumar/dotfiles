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
            -- JetBrains Darcula syntax highlighting
            highlight_overrides = {
                mocha = function()
                    return {
                        -- ── Keywords ── #CC7832 (orange)
                        ["@keyword"]                    = { fg = "#CC7832", bold = true },
                        ["@keyword.function"]           = { fg = "#CC7832", bold = true },
                        ["@keyword.return"]             = { fg = "#CC7832", bold = true },
                        ["@keyword.operator"]           = { fg = "#CC7832" },
                        ["@keyword.import"]             = { fg = "#CC7832" },
                        ["@keyword.conditional"]        = { fg = "#CC7832", bold = true },
                        ["@keyword.repeat"]             = { fg = "#CC7832", bold = true },
                        ["@keyword.exception"]          = { fg = "#CC7832", bold = true },
                        ["@keyword.type"]               = { fg = "#CC7832", bold = true },
                        ["@keyword.modifier"]           = { fg = "#CC7832", bold = true },
                        ["@keyword.coroutine"]          = { fg = "#CC7832", bold = true },
                        ["@keyword.debug"]              = { fg = "#CC7832" },
                        ["@keyword.directive"]          = { fg = "#CC7832" },
                        ["@conditional"]                = { fg = "#CC7832", bold = true },
                        ["@repeat"]                     = { fg = "#CC7832", bold = true },
                        ["@exception"]                  = { fg = "#CC7832", bold = true },
                        ["@include"]                    = { fg = "#CC7832" },
                        ["@operator"]                   = { fg = "#CC7832" },
                        ["@storageclass"]               = { fg = "#CC7832", bold = true },
                        ["@type.qualifier"]             = { fg = "#CC7832", bold = true },

                        -- ── Strings ── #6A8759 (olive green)
                        ["@string"]                     = { fg = "#6A8759" },
                        ["@string.regex"]               = { fg = "#6A8759" },
                        ["@string.escape"]              = { fg = "#CC7832" },
                        ["@string.special"]             = { fg = "#6A8759" },
                        ["@string.documentation"]       = { fg = "#629755" },
                        ["@character"]                  = { fg = "#6A8759" },
                        ["@character.special"]          = { fg = "#CC7832" },

                        -- ── Numbers / Booleans ── #6897BB (steel blue)
                        ["@number"]                     = { fg = "#6897BB" },
                        ["@number.float"]               = { fg = "#6897BB" },
                        ["@float"]                      = { fg = "#6897BB" },
                        ["@boolean"]                    = { fg = "#6897BB" },

                        -- ── Functions / Methods ── #FFC66D (warm yellow)
                        ["@function"]                   = { fg = "#FFC66D" },
                        ["@function.call"]              = { fg = "#FFC66D" },
                        ["@function.builtin"]           = { fg = "#FFC66D" },
                        ["@function.macro"]             = { fg = "#FFC66D" },
                        ["@function.method"]            = { fg = "#FFC66D" },
                        ["@function.method.call"]       = { fg = "#FFC66D" },
                        ["@method"]                     = { fg = "#FFC66D" },
                        ["@method.call"]                = { fg = "#FFC66D" },
                        ["@constructor"]                = { fg = "#FFC66D" },

                        -- ── Constants ── #9876AA (lavender/purple)
                        ["@constant"]                   = { fg = "#9876AA" },
                        ["@constant.builtin"]           = { fg = "#9876AA" },
                        ["@constant.macro"]             = { fg = "#9876AA" },
                        ["@enumMember"]                 = { fg = "#9876AA" },
                        ["@enum.member"]                = { fg = "#9876AA" },

                        -- ── Types ── #A9B7C6 (default light blue-gray)
                        ["@type"]                       = { fg = "#A9B7C6" },
                        ["@type.builtin"]               = { fg = "#CC7832", bold = true },
                        ["@type.definition"]            = { fg = "#A9B7C6" },

                        -- ── Variables / Identifiers ── #A9B7C6 (default)
                        ["@variable"]                   = { fg = "#A9B7C6" },
                        ["@variable.builtin"]           = { fg = "#9876AA" },
                        ["@variable.parameter"]         = { fg = "#A9B7C6" },
                        ["@variable.member"]            = { fg = "#A9B7C6" },
                        ["@field"]                      = { fg = "#A9B7C6" },
                        ["@property"]                   = { fg = "#A9B7C6" },
                        ["@identifier"]                 = { fg = "#A9B7C6" },
                        ["@namespace"]                  = { fg = "#A9B7C6" },
                        ["@module"]                     = { fg = "#A9B7C6" },

                        -- ── Comments ── #808080 (gray)
                        ["@comment"]                    = { fg = "#808080", italic = true },
                        ["@comment.documentation"]      = { fg = "#629755", italic = true },
                        ["@comment.error"]              = { fg = "#808080", italic = true },
                        ["@comment.warning"]            = { fg = "#808080", italic = true },
                        ["@comment.todo"]               = { fg = "#BBB529", bold = true },
                        ["@comment.note"]               = { fg = "#629755", bold = true },
                        Comment                         = { fg = "#808080", italic = true },

                        -- ── Annotations / Decorators ── #BBB529 (yellow-green)
                        ["@attribute"]                  = { fg = "#BBB529" },
                        ["@attribute.builtin"]          = { fg = "#BBB529" },
                        ["@label"]                      = { fg = "#BBB529" },

                        -- ── Punctuation ── subdued
                        ["@punctuation.bracket"]        = { fg = "#A9B7C6" },
                        ["@punctuation.delimiter"]      = { fg = "#A9B7C6" },
                        ["@punctuation.special"]        = { fg = "#CC7832" },

                        -- ── LSP Semantic Tokens ──
                        ["@lsp.type.keyword"]           = { fg = "#CC7832", bold = true },
                        ["@lsp.type.string"]            = { fg = "#6A8759" },
                        ["@lsp.type.number"]            = { fg = "#6897BB" },
                        ["@lsp.type.function"]          = { fg = "#FFC66D" },
                        ["@lsp.type.method"]            = { fg = "#FFC66D" },
                        ["@lsp.type.enum"]              = { fg = "#A9B7C6" },
                        ["@lsp.type.enumMember"]        = { fg = "#9876AA" },
                        ["@lsp.type.type"]              = { fg = "#A9B7C6" },
                        ["@lsp.type.class"]             = { fg = "#A9B7C6" },
                        ["@lsp.type.struct"]            = { fg = "#A9B7C6" },
                        ["@lsp.type.interface"]         = { fg = "#A9B7C6" },
                        ["@lsp.type.variable"]          = { fg = "#A9B7C6" },
                        ["@lsp.type.parameter"]         = { fg = "#A9B7C6" },
                        ["@lsp.type.property"]          = { fg = "#A9B7C6" },
                        ["@lsp.type.namespace"]         = { fg = "#A9B7C6" },
                        ["@lsp.type.macro"]             = { fg = "#FFC66D" },
                        ["@lsp.type.decorator"]         = { fg = "#BBB529" },
                        ["@lsp.type.comment"]           = { fg = "#808080", italic = true },
                        ["@lsp.type.selfKeyword"]       = { fg = "#9876AA" },
                        ["@lsp.typemod.function.declaration"]   = { fg = "#FFC66D" },
                        ["@lsp.typemod.method.declaration"]     = { fg = "#FFC66D" },
                        ["@lsp.typemod.variable.constant"]      = { fg = "#9876AA" },
                        ["@lsp.typemod.variable.readonly"]      = { fg = "#9876AA" },
                    }
                end,
            },
        })
        vim.cmd.colorscheme "catppuccin"
    end
}
