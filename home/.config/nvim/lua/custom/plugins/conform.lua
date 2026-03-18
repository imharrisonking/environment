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
    opts = function()
        local function has_tool_ruff(pyproject_path)
            local lines = vim.fn.readfile(pyproject_path)
            for _, line in ipairs(lines) do
                if line:match('^%[tool%.ruff') then
                    return true
                end
            end
            return false
        end

        local function find_ruff_config(bufnr)
            local file = vim.api.nvim_buf_get_name(bufnr)
            if file == '' then
                return nil
            end

            local start_dir = vim.fs.dirname(file)
            if not start_dir then
                return nil
            end

            local ruff_config = vim.fs.find({ 'ruff.toml', '.ruff.toml' }, {
                upward = true,
                path = start_dir,
                type = 'file',
            })[1]
            if ruff_config then
                return ruff_config
            end

            local pyproject = vim.fs.find({ 'pyproject.toml' }, {
                upward = true,
                path = start_dir,
                type = 'file',
            })[1]

            if pyproject and has_tool_ruff(pyproject) then
                return pyproject
            end

            return nil
        end

        return {
        formatters_by_ft = {
            -- C/C++
            c = { 'clang-format' },
            cpp = { 'clang-format' },

            -- Go
            go = { 'goimports', 'gofmt' },

            -- Lua
            lua = (vim.fn.executable('stylua') == 1) and { 'stylua' } or {},

            -- Web technologies
            javascript = { 'prettier' },
            typescript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescriptreact = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            yaml = { 'prettier' },
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
            ruff_format = {
                condition = function(_, ctx)
                    return find_ruff_config(ctx.buf) ~= nil
                end,
                prepend_args = function(_, ctx)
                    local config = find_ruff_config(ctx.buf)
                    return config and { '--config', config } or {}
                end,
            },
            ruff_organize_imports = {
                condition = function(_, ctx)
                    return find_ruff_config(ctx.buf) ~= nil
                end,
                prepend_args = function(_, ctx)
                    local config = find_ruff_config(ctx.buf)
                    return config and { '--config', config } or {}
                end,
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
            if vim.bo[bufnr].filetype == 'python' then
                local ruff_config = find_ruff_config(bufnr)
                if not ruff_config then
                    return nil
                end

                return {
                    timeout_ms = 1000,
                    lsp_format = 'never',
                }
            end

            return {
                timeout_ms = 1000,
                lsp_format = 'fallback',
            }
        end,
    }
    end,
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
