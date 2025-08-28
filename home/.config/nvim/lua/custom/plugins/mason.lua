return {
    {
        "williamboman/mason.nvim",
        lazy = false, -- Load immediately to ensure PATH is set
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ensure_installed = {
                -- LSP servers (only for installed languages)
                "lua-language-server",         -- Lua LSP
                "typescript-language-server",  -- TypeScript LSP
                "tailwindcss-language-server", -- Tailwind CSS LSP
                "html-lsp",                    -- HTML LSP
                "css-lsp",                     -- CSS LSP
                "vue-language-server",         -- Vue LSP
                "pyright",                     -- Python LSP

                -- Formatters (only for installed languages)
                "stylua",         -- Lua formatter
                "prettier",       -- JS/TS/JSON/HTML/CSS formatter
                "black",          -- Python formatter
                "isort",          -- Python import sorter

                -- Linters (only for installed languages)
                "eslint_d",       -- JS/TS linting
                "pylint",         -- Python linter
                "flake8",         -- Python linter

                -- Debuggers (only for installed languages)
                "debugpy",        -- Python debugger

                -- System tools (don't require specific language toolchains)
                "shellcheck",     -- Shell linter (works with system shell)
                "markdownlint",   -- Markdown linting
                "jsonlint",       -- JSON linting
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            -- Auto-install ensure_installed tools with better error handling
            local mr = require("mason-registry")
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    if mr.has_package(tool) then
                        local p = mr.get_package(tool)
                        if not p:is_installed() then
                            vim.notify("Mason: Installing " .. tool .. "...", vim.log.levels.INFO)
                            p:install():once("closed", function()
                                if p:is_installed() then
                                    vim.notify("Mason: Successfully installed " .. tool, vim.log.levels.INFO)
                                else
                                    vim.notify("Mason: Failed to install " .. tool, vim.log.levels.ERROR)
                                end
                            end)
                        end
                    else
                        vim.notify("Mason: Package '" .. tool .. "' not found", vim.log.levels.WARN)
                    end
                end
            end

            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
}