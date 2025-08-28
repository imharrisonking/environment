return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  config = function()
    local lspconfig = require 'lspconfig'
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- LSP keybindings
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = { buffer = event.buf }
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Custom TypeScript/JavaScript handling
        if client.name == 'vtsls' then
          vim.keymap.set('n', 'gd', function()
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, 'typescript.goToSourceDefinition', params, function(err, result, ctx, config)
              if err or not result or vim.tbl_isempty(result) then
                vim.lsp.buf.definition()
              else
                vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
              end
            end)
          end, opts)
          vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        -- Custom Python handling
        elseif client.name == 'pyright' then
          vim.keymap.set('n', 'gd', function()
            local params = vim.lsp.util.make_position_params()
            local current_pos = vim.api.nvim_win_get_cursor(0)
            local current_buf = vim.api.nvim_get_current_buf()

            vim.lsp.buf_request(0, 'textDocument/declaration', params, function(err, result, ctx, config)
              if err or not result or vim.tbl_isempty(result) then
                vim.lsp.buf.definition()
              else
                local target = result[1] or result
                local target_buf = vim.uri_to_bufnr(target.uri or target.targetUri)
                local target_line = target.range and target.range.start.line or target.targetRange.start.line

                if target_buf == current_buf and math.abs(target_line - (current_pos[1] - 1)) <= 5 then
                  vim.lsp.buf.definition()
                else
                  vim.lsp.util.jump_to_location(target, client.offset_encoding)
                end
              end
            end)
          end, opts)
          vim.keymap.set('n', 'gI', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        end

        -- Additional custom keybindings
        vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<cr>', { desc = 'View Diagnostics' })
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
      end,
    })

    -- Mason setup
    require('mason-lspconfig').setup {
      ensure_installed = {
        'astro',
        'cssls',
        'vtsls',
        'cssmodules_ls',
        'lua_ls',
        'pyright',
        'html',
        'marksman',
      },
      automatic_installation = true,
    }

    -- Setup handlers for automatic server configuration
    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          lspconfig[server_name].setup { capabilities = capabilities }
        end,

        ['pyright'] = function()
          lspconfig.pyright.setup {
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  -- Type checking mode (off, basic, strict)
                  typeCheckingMode = 'basic',
                  -- Auto import completions
                  autoImportCompletions = true,
                  -- Auto search paths
                  autoSearchPaths = true,
                  -- Use library code for types when no type stubs available
                  useLibraryCodeForTypes = true,
                  -- Diagnostic mode
                  diagnosticMode = 'workspace',
                  -- Inlay hints (similar to VSCode Python settings)
                  inlayHints = {
                    variableTypes = true,
                    functionReturnTypes = true,
                    parameterTypes = true,
                    pytestParameters = true,
                  },
                  -- Enable specific diagnostics similar to VSCode defaults
                  diagnosticSeverityOverrides = {
                    reportUnusedImport = 'warning',
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
            root_dir = lspconfig.util.root_pattern('.git', 'pnpm-workspace.yaml', 'pnpm-lock.yaml', 'yarn.lock', 'package-lock.json', 'bun.lockb'),
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
                  maxTsServerMemory = 12288,
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
      },
    }
  end,
}

