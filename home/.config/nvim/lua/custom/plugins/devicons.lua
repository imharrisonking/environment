return {
    'nvim-tree/nvim-web-devicons',
    lazy = false, -- Load immediately to ensure other plugins can use it
    priority = 1000, -- Load early
    config = function()
        -- Use vim.schedule to delay setup until after other plugins are loaded
        vim.schedule(function()
            local icons = require 'config.icons'

            require('nvim-web-devicons').setup {
                override = {
                    -- Python files
                    py = {
                        icon = icons.languages.Python,
                        color = '#51a0cf',
                        cterm_color = '226',
                        name = 'Python',
                    },

                    -- React/JSX files
                    jsx = {
                        icon = icons.languages.React,
                        color = '#7DAFA4',
                        cterm_color = '117',
                        name = 'ReactJSX',
                    },

                    -- React/TSX files
                    tsx = {
                        icon = icons.languages.React,
                        color = '#7DAFA4',
                        cterm_color = '117',
                        name = 'TypeScriptTSX',
                    },

                    -- TypeScript files
                    ts = {
                        icon = icons.languages.TypeScript,
                        color = '#7DAFA4',
                        cterm_color = '67',
                        name = 'TypeScript',
                    },

                    -- JavaScript files
                    js = {
                        icon = icons.languages.JavaScript,
                        color = '#E2A346',
                        cterm_color = '220',
                        name = 'JavaScript',
                    },

                    -- C++ files
                    cpp = {
                        icon = icons.languages.Cpp,
                        color = '#7DAFA4',
                        cterm_color = '204',
                        name = 'CPlusPlus',
                    },

                    -- -- Additional language files using your icons
                    -- lua = {
                    --   icon = icons.languages.Lua,
                    --   color = '#51a0cf',
                    --   cterm_color = '74',
                    --   name = 'Lua',
                    -- },
                    --
                    -- rust = {
                    --   icon = icons.languages.Rust,
                    --   color = '#dea584',
                    --   cterm_color = '216',
                    --   name = 'Rust',
                    -- },
                    --
                    -- go = {
                    --   icon = icons.languages.Go,
                    --   color = '#519aba',
                    --   cterm_color = '67',
                    --   name = 'Go',
                    -- },
                    --
                    -- html = {
                    --   icon = icons.languages.HTML,
                    --   color = '#e34c26',
                    --   cterm_color = '196',
                    --   name = 'Html',
                    -- },
                    --
                    -- css = {
                    --   icon = icons.languages.CSS,
                    --   color = '#1572b6',
                    --   cterm_color = '33',
                    --   name = 'Css',
                    -- },
                    --
                    -- md = {
                    --   icon = icons.languages.Markdown,
                    --   color = '#519aba',
                    --   cterm_color = '67',
                    --   name = 'Markdown',
                    -- },
                    --
                    -- json = {
                    --   icon = icons.languages.JSON,
                    --   color = '#cbcb41',
                    --   cterm_color = '185',
                    --   name = 'Json',
                    -- },
                    --
                    -- yml = {
                    --   icon = icons.languages.YAML,
                    --   color = '#cb171e',
                    --   cterm_color = '161',
                    --   name = 'Yaml',
                    -- },
                    --
                    -- yaml = {
                    --   icon = icons.languages.YAML,
                    --   color = '#cb171e',
                    --   cterm_color = '161',
                    --   name = 'Yaml',
                    -- },
                },
                -- Globally show colors
                color_icons = true,
                -- Globally enable default icons (will use defaults if nothing specified)
                default = true,
                -- Add strict mode to prevent invalid highlight groups
                strict = true,
            }
        end)
    end,
}
