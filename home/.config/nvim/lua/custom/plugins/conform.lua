return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>cf',
            function()
                require('conform').format({ async = true }, function(err, did_edit)
                    if not err and did_edit then
                        vim.notify('Code formatted', vim.log.levels.INFO, { title = 'Conform' })
                    end
                end)
            end,
            mode = { 'n', 'v' },
            desc = 'Format buffer',
        },
    },
    opts = {
        formatters_by_ft = {
            -- C/C++
            c = { 'clang-format' },
            cpp = { 'clang-format' },

            -- Go
            go = { 'goimports', 'gofmt' },

            -- Lua
            lua = { 'stylua' },

            -- Web technologies
            javascript = { 'prettier' },
            typescript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescriptreact = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier' },
            html = { 'prettier' },
            css = { 'prettier' },
            scss = { 'prettier' },

            -- Python
            python = { 'ruff_format', 'ruff_organize_imports' }, -- using ruff for both formatting and import sorting

            -- Shell
            sh = { 'shfmt' },
            bash = { 'shfmt' },

            -- Other (system tools)
            rust = { 'rustfmt' }, -- comes with Rust installations

            -- Docker
            dockerfile = { 'hadolint' },
        },
        formatters = {
            ['clang-format'] = {
                prepend_args = { '--style={IndentWidth: 4, UseTab: Never}' },
            },
            prettier = {
                prepend_args = { '--tab-width', '4', '--use-tabs', 'false' },
            },
            stylua = {
                prepend_args = { '--indent-type', 'Spaces', '--indent-width', '4' },
            },
            shfmt = {
                prepend_args = { '-i', '4' },
            },
        },
        default_format_opts = {
            lsp_format = 'fallback',
        },
        format_on_save = function(bufnr)
            -- Disable format_on_save for Python
            local disable_filetypes = { python = true }
            if disable_filetypes[vim.bo[bufnr].filetype] then
                return nil
            else
                return {
                    timeout_ms = 1000,
                    lsp_format = 'fallback',
                }
            end
        end,
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
