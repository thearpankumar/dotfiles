return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap"
        },
        config = function()
            local jdtls_dir = vim.fn.stdpath('data') .. '/mason/packages/jdtls'
            local config_dir = jdtls_dir .. '/config_linux'
            local plugins_dir = jdtls_dir .. '/plugins/'
            local path_to_jar = plugins_dir .. 'org.eclipse.equinox.launcher_*.jar'

            local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
            local root_dir = require('jdtls.setup').find_root(root_markers)

            if root_dir == nil then
                return
            end

            local workspace_dir = vim.fn.fnamemodify(root_dir, ':p:h:t')

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'java',
                callback = function()
                    local config = {
                        cmd = {
                            'java',
                            '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                            '-Dosgi.bundles.defaultStartLevel=4',
                            '-Declipse.product=org.eclipse.jdt.ls.core.product',
                            '-Dlog.protocol=true',
                            '-Dlog.level=ALL',
                            '-Xms1g',
                            '--add-modules=ALL-SYSTEM',
                            '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                            '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                            '-jar', vim.fn.glob(path_to_jar),
                            '-configuration', config_dir,
                            '-data', vim.fn.expand('~/.cache/jdtls-workspace') .. '/' .. workspace_dir,
                        },
                        root_dir = root_dir,
                        settings = {
                            java = {}
                        },
                        init_options = {
                            bundles = {}
                        },
                    }

                    -- Setup keymaps for Java
                    local opts = { buffer = 0 }
                    vim.keymap.set('n', '<leader>jo', require('jdtls').organize_imports, opts)
                    vim.keymap.set('n', '<leader>jv', require('jdtls').extract_variable, opts)
                    vim.keymap.set('n', '<leader>jc', require('jdtls').extract_constant, opts)
                    vim.keymap.set('n', '<leader>jm', require('jdtls').extract_method, opts)
                    vim.keymap.set('n', '<leader>jr', require('jdtls').rename_file, opts)

                    require('jdtls').start_or_attach(config)
                end
            })
        end
    }
}