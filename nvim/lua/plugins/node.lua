return {
    {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    },
    {
        "mxsdev/nvim-dap-vscode-js",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        dependencies = {
            "mfussenegger/nvim-dap",
            "microsoft/vscode-js-debug"
        },
        config = function()
            require("dap-vscode-js").setup({
                debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
                adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }
            })

            for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "launch",
                        name = "Launch file",
                        program = "${file}",
                        cwd = "${workspaceFolder}",
                    },
                    {
                        type = "pwa-node",
                        request = "attach",
                        name = "Attach",
                        processId = require("dap.utils").pick_process,
                        cwd = "${workspaceFolder}",
                    }
                }
            end
        end
    }
}