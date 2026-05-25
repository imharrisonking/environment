return {
    {
        -- Lua development completion and annotations
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
        },
    },

    -- Helper to detect unsupported platforms for certain Mason packages
    {
        'williamboman/mason.nvim',
        lazy = false,
        cmd = 'Mason',
        keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
        build = ':MasonUpdate',
        opts = function()
            local uname = vim.loop.os_uname()
            local is_arm64_linux = uname.sysname == 'Linux' and uname.machine == 'aarch64'

            local ensure_installed = {
                'lua-language-server',
                'vtsls',
                'tailwindcss-language-server',
                'html-lsp',
                'css-lsp',
                'vue-language-server',
                'ruff',
                'basedpyright',
                'stylua',
                'prettier',
                'black',
                'isort',
                'clang-format',
                'eslint_d',
                'pylint',
                'flake8',
                'debugpy',
                'codelldb',
                'shellcheck',
                'markdownlint',
                'jsonlint',
                'mdx-analyzer',
            }

            if not is_arm64_linux then
                table.insert(ensure_installed, 'clangd')
            end

            return { ensure_installed = ensure_installed }
        end,
        config = function(_, opts)
            require('mason').setup(opts)

            local mason_bin = vim.fn.stdpath('data') .. '/mason/bin'
            local current_path = vim.env.PATH or ''
            if not string.find(current_path, mason_bin, 1, true) then
                vim.env.PATH = mason_bin .. ':' .. current_path
            end

            local mr = require('mason-registry')
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    if mr.has_package(tool) then
                        local p = mr.get_package(tool)
                        if not p:is_installed() then
                            vim.notify('Mason: Installing ' .. tool .. '...', vim.log.levels.INFO)
                            p:install():once('closed', function()
                                if p:is_installed() then
                                    vim.notify('Mason: Successfully installed ' .. tool, vim.log.levels.INFO)
                                else
                                    vim.notify('Mason: Failed to install ' .. tool, vim.log.levels.ERROR)
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

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'saghen/blink.cmp',
            'williamboman/mason.nvim',
            'mason-org/mason-lspconfig.nvim',
        },
        config = function()
            local lspconfig = require 'lspconfig'
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            local ok_configs, configs = pcall(require, 'lspconfig.configs')
            if ok_configs and configs and configs.stylua then
                lspconfig.stylua.setup {
                    autostart = false,
                }
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }
                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    vim.keymap.set('n', '<leader>k', function()
                        local bufnr = event.buf
                        local enabled = false

                        if vim.lsp.inlay_hint and vim.lsp.inlay_hint.is_enabled then
                            local ok, result = pcall(vim.lsp.inlay_hint.is_enabled, { bufnr = bufnr })
                            if not ok then
                                ok, result = pcall(vim.lsp.inlay_hint.is_enabled, bufnr)
                            end
                            if ok then
                                enabled = result
                            end
                        end

                        if vim.lsp.inlay_hint and vim.lsp.inlay_hint.enable then
                            local ok = pcall(vim.lsp.inlay_hint.enable, not enabled, { bufnr = bufnr })
                            if not ok then
                                pcall(vim.lsp.inlay_hint.enable, bufnr, not enabled)
                            end
                        end
                    end, { buffer = event.buf, desc = 'Toggle Inlay Hints' })

                    if client and client.server_capabilities.documentSymbolProvider then
                        local ok, navic = pcall(require, 'nvim-navic')
                        if ok then
                            navic.attach(client, event.buf)
                        end
                    end

                    -- Defaults for all LSPs (can be overridden per-server below)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)

                    if client.name == 'vtsls' then
                        vim.keymap.set('n', 'gd', function()
                            local params = vim.lsp.util.make_position_params()
                            vim.lsp.buf_request(0, 'typescript.goToSourceDefinition', params, function(err, result)
                                if err or not result or vim.tbl_isempty(result) then
                                    vim.lsp.buf.definition()
                                else
                                    vim.lsp.util.show_document(result[1], client.offset_encoding, { focus = true, reuse_win = true })
                                end
                            end)
                        end, opts)
                        vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    elseif client.name == 'basedpyright' then
                        vim.keymap.set('n', 'gd', function()
                            local params = vim.lsp.util.make_position_params()
                            local current_pos = vim.api.nvim_win_get_cursor(0)
                            local current_buf = vim.api.nvim_get_current_buf()

                            vim.lsp.buf_request(0, 'textDocument/declaration', params, function(err, result)
                                if err or not result or vim.tbl_isempty(result) then
                                    vim.lsp.buf.definition()
                                else
                                    local target = result[1] or result
                                    local target_buf = vim.uri_to_bufnr(target.uri or target.targetUri)
                                    local target_line = target.range and target.range.start.line or target.targetRange.start.line

                                    if target_buf == current_buf and math.abs(target_line - (current_pos[1] - 1)) <= 5 then
                                        vim.lsp.buf.definition()
                                    else
                                        vim.lsp.util.show_document(target, client.offset_encoding, { focus = true, reuse_win = true })
                                    end
                                end
                            end)
                        end, opts)
                        vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    elseif client.name == 'clangd' then
                        vim.keymap.set('n', 'gd', function()
                            local params = vim.lsp.util.make_position_params()
                            vim.lsp.buf_request(0, 'textDocument/declaration', params, function(err, result)
                                if err or not result or vim.tbl_isempty(result) then
                                    vim.lsp.buf.definition()
                                else
                                    local target = result[1] or result
                                    vim.lsp.util.show_document(target, client.offset_encoding, { focus = true, reuse_win = true })
                                end
                            end)
                        end, opts)
                        vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    end

                    vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = 'View Diagnostics' })
                    vim.keymap.set('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                end,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == 'ruff' then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
                desc = 'LSP: Disable hover capability from Ruff',
            })

            local uname = vim.loop.os_uname()
            local is_arm64_linux = uname.sysname == 'Linux' and uname.machine == 'aarch64'

            local servers = {
                'astro',
                'cssls',
                'vtsls',
                'cssmodules_ls',
                'lua_ls',
                'ruff',
                'basedpyright',
                'html',
                'marksman',
                'mdx_analyzer',
            }

            if not is_arm64_linux then
                table.insert(servers, 'clangd')
            end

            require('mason-lspconfig').setup {
                ensure_installed = servers,
                automatic_installation = true,
            }

            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        if server_name == 'ts_ls' then
                            return
                        end
                        lspconfig[server_name].setup { capabilities = capabilities }
                    end,

                    ['ruff'] = function()
                        lspconfig.ruff.setup {
                            capabilities = capabilities,
                            root_dir = function(fname)
                                local ok, uv = pcall(require, 'uv')
                                if ok and uv.get_project_root then
                                    local uv_root = uv.get_project_root(fname)
                                    if uv_root then
                                        return uv_root
                                    end
                                end

                                return lspconfig.util.root_pattern('pyproject.toml', 'ruff.toml', '.ruff.toml', 'setup.py', '.git')(fname)
                            end,
                            init_options = {
                                settings = {
                                    lineLength = 88,
                                    args = {},
                                },
                            },
                        }
                    end,

                    ['lua_ls'] = function()
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    hint = {
                                        enable = true,
                                        setType = true,
                                        paramType = true,
                                        paramName = 'All',
                                        semicolon = 'Disable',
                                        arrayIndex = 'Disable',
                                    },
                                },
                            },
                        }
                    end,

                    ['basedpyright'] = function()
                        local function get_basedpyright_cmd()
                            local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin/basedpyright-langserver'
                            if vim.fn.executable(mason_bin) == 1 then
                                return { mason_bin, '--stdio' }
                            end
                            if vim.fn.isdirectory(vim.fn.getcwd() .. '/.venv') == 1 then
                                return { 'uv', 'run', 'basedpyright-langserver', '--stdio' }
                            end
                            return { 'basedpyright-langserver', '--stdio' }
                        end

                        lspconfig.basedpyright.setup {
                            capabilities = capabilities,
                            cmd = get_basedpyright_cmd(),
                            settings = {
                                basedpyright = {
                                    disableOrganizeImports = true,
                                },
                                python = {
                                    analysis = {
                                        typeCheckingMode = 'basic',
                                        autoImportCompletions = true,
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                        diagnosticMode = 'workspace',
                                        inlayHints = {
                                            variableTypes = true,
                                            functionReturnTypes = true,
                                            parameterTypes = true,
                                            pytestParameters = true,
                                        },
                                        diagnosticSeverityOverrides = {
                                            reportUnusedImport = 'none',
                                            reportUnusedVariable = 'warning',
                                            reportUnusedFunction = 'warning',
                                            reportUnusedClass = 'warning',
                                            reportMissingImports = 'error',
                                            reportMissingTypeStubs = 'none',
                                            reportGeneralTypeIssues = 'error',
                                            reportOptionalMemberAccess = 'error',
                                            reportOptionalCall = 'error',
                                            reportOptionalIterable = 'error',
                                            reportOptionalContextManager = 'error',
                                            reportOptionalOperand = 'error',
                                            reportPrivateImportUsage = 'warning',
                                        },
                                    },
                                },
                            },
                        }
                    end,

                    ['vtsls'] = function()
                        lspconfig.vtsls.setup {
                            capabilities = capabilities,
                            root_dir = lspconfig.util.root_pattern('package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'package.json', '.git'),
                            settings = {
                                typescript = {
                                    preferences = {
                                        importModuleSpecifier = 'relative',
                                    },
                                    inlayHints = {
                                        parameterNames = { enabled = 'literals' },
                                        parameterTypes = { enabled = true },
                                        variableTypes = { enabled = true },
                                        propertyDeclarationTypes = { enabled = true },
                                        functionLikeReturnTypes = { enabled = true },
                                        enumMemberValues = { enabled = true },
                                    },
                                    tsserver = {
                                        maxTsServerMemory = 4096,
                                    },
                                },
                                javascript = {
                                    inlayHints = {
                                        parameterNames = { enabled = 'literals' },
                                        parameterTypes = { enabled = true },
                                        variableTypes = { enabled = true },
                                        propertyDeclarationTypes = { enabled = true },
                                        functionLikeReturnTypes = { enabled = true },
                                        enumMemberValues = { enabled = true },
                                    },
                                },
                            },
                        }
                    end,

                    ['clangd'] = function()
                        lspconfig.clangd.setup {
                            capabilities = capabilities,
                            cmd = {
                                'clangd',
                                '--background-index',
                                '--clang-tidy',
                                '--inlay-hints=true',
                                '--header-insertion=iwyu',
                                '--completion-style=detailed',
                                '--function-arg-placeholders',
                                '--fallback-style=llvm',
                            },
                            init_options = {
                                usePlaceholders = true,
                                completeUnimported = true,
                                clangdFileStatus = true,
                            },
                            root_dir = lspconfig.util.root_pattern('.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac', '.git'),
                        }
                    end,

                    ['mdx_analyzer'] = function()
                        lspconfig.mdx_analyzer.setup {
                            capabilities = capabilities,
                            cmd = { vim.fn.stdpath 'data' .. '/mason/bin/mdx-language-server', '--stdio' },
                            root_dir = lspconfig.util.root_pattern('package.json', '.git'),
                            filetypes = { 'mdx' },
                            settings = {
                                mdx = {
                                    validate = true,
                                    experimentalFeatures = {
                                        frontmatter = true,
                                    },
                                },
                            },
                        }
                    end,
                },
            }
        end,
    },

    {
        'benomahony/uv.nvim',
        opts = {
            picker_integration = true,
        },
    },

    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = 'VeryLazy',
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup {
                preset = 'classic',
                transparent_bg = false,
                transparent_cursorline = false,
                hi = {
                    error = 'DiagnosticError',
                    warn = 'DiagnosticWarn',
                    info = 'DiagnosticInfo',
                    hint = 'DiagnosticHint',
                    arrow = 'NonText',
                    background = 'CursorLine',
                    mixing_color = 'None',
                },
                options = {
                    show_source = {
                        enabled = false,
                        if_many = false,
                    },
                    use_icons_from_diagnostic = false,
                    set_arrow_to_diag_color = false,
                    add_messages = true,
                    throttle = 20,
                    softwrap = 30,
                    multilines = {
                        enabled = false,
                        always_show = false,
                    },
                    show_all_diags_on_cursorline = false,
                    enable_on_insert = false,
                    enable_on_select = false,
                    overflow = {
                        mode = 'wrap',
                        padding = 0,
                    },
                    break_line = {
                        enabled = false,
                        after = 30,
                    },
                    format = nil,
                    virt_texts = {
                        priority = 2048,
                    },
                    severity = {
                        vim.diagnostic.severity.ERROR,
                        vim.diagnostic.severity.WARN,
                        vim.diagnostic.severity.INFO,
                        vim.diagnostic.severity.HINT,
                    },
                    overwrite_events = nil,
                },
                disabled_ft = {},
            }
            vim.diagnostic.config { virtual_text = false }
        end,
    },
}
