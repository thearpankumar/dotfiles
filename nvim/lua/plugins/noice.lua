return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("noice").setup({
            cmdline = {
                enabled = true,
                view = "cmdline_popup",
                format = {
                    cmdline     = { icon = "" },
                    search_down = { icon = " " },
                    search_up   = { icon = " " },
                    filter      = { icon = "$" },
                    lua         = { icon = "" },
                    help        = { icon = "?" },
                },
            },
            messages = { enabled = true },
            popupmenu = { enabled = true },
            notify    = { enabled = false }, -- keep your existing notify if any
            lsp = {
                progress = { enabled = false },
                hover    = { enabled = false }, -- keep native LSP hover
                signature = { enabled = false },
                message  = { enabled = true },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = "45%",  -- vertical center
                        col = "50%",  -- horizontal center
                    },
                    size = {
                        width  = 70,
                        height = "auto",
                    },
                    border = {
                        style   = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = "55%",
                        col = "50%",
                    },
                    size = {
                        width  = 70,
                        height = 10,
                    },
                    border = {
                        style   = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = "Normal:Normal,FloatBorder:DiagnosticInfo",
                    },
                },
            },
            routes = {
                -- hide "written" messages
                { filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
                -- hide search count noise
                { filter = { event = "msg_show", find = "search hit" }, opts = { skip = true } },
            },
        })
    end,
}
