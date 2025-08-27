return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Load NvChad defaults
    require("nvchad.configs.lspconfig").defaults()

    local lspconfig = require("lspconfig")
    local lspconfig_defaults = lspconfig.util.default_config

    -- Extend default capabilities with nvim-cmp
    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
      "force",
      lspconfig_defaults.capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    -- LSP keybindings
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        
        -- For TypeScript/JavaScript files, use "Go to Source Definition" if available
        if client.name == "vtsls" then
          vim.keymap.set("n", "gd", function()
            -- Try to use TypeScript's "Go to Source Definition" first
            local params = vim.lsp.util.make_position_params()
            vim.lsp.buf_request(0, "typescript.goToSourceDefinition", params, function(err, result, ctx, config)
              if err or not result or vim.tbl_isempty(result) then
                -- Fallback to regular definition if source definition is not available
                vim.lsp.buf.definition()
              else
                -- Handle the result like regular definition
                vim.lsp.util.jump_to_location(result[1], client.offset_encoding)
              end
            end)
          end, opts)
          -- Add alternative keybinding for regular definition
          vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        -- For Python files, use Pyright's special handling
        elseif client.name == "pyright" then
          vim.keymap.set("n", "gd", function()
            -- For Python, try declaration first (goes to actual definition, not import)
            -- If that fails or returns the same location, use definition
            local params = vim.lsp.util.make_position_params()
            local current_pos = vim.api.nvim_win_get_cursor(0)
            local current_buf = vim.api.nvim_get_current_buf()
            
            vim.lsp.buf_request(0, "textDocument/declaration", params, function(err, result, ctx, config)
              if err or not result or vim.tbl_isempty(result) then
                -- Fallback to regular definition
                vim.lsp.buf.definition()
              else
                local target = result[1] or result
                local target_buf = vim.uri_to_bufnr(target.uri or target.targetUri)
                local target_line = target.range and target.range.start.line or target.targetRange.start.line
                
                -- Check if declaration points to same file and similar position (likely an import)
                if target_buf == current_buf and math.abs(target_line - (current_pos[1] - 1)) <= 5 then
                  -- Declaration is too close, likely an import, use definition instead
                  vim.lsp.buf.definition()
                else
                  -- Jump to the declaration (actual definition)
                  vim.lsp.util.jump_to_location(target, client.offset_encoding)
                end
              end
            end)
          end, opts)
          -- Add alternative keybinding for regular definition (goes to import)
          vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        else
          -- For all other languages, use regular definition
          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        end
        
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        vim.keymap.set("n", "<leader>vd", "<cmd>lua vim.diagnostic.open_float()<cr>", { desc = "View Diagnostics" })
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
      end,
    })

    -- Setup Mason
    require("mason").setup()

    -- Setup Mason-LSPconfig
    require("mason-lspconfig").setup({
      ensure_installed = {
        "astro",
        "cssls",
        "vtsls",
        "cssmodules_ls",
        "gopls",
        "lua_ls",
        "pyright",
        "html",
        "marksman",
        "clangd",
      },
      automatic_installation = true,
    })

    -- Setup handlers for automatic server configuration
    require("mason-lspconfig").setup_handlers({
      -- Default handler for all servers
      function(server_name)
        lspconfig[server_name].setup({})
      end,

      -- Custom configuration for vtsls (TypeScript/JavaScript)
      ["vtsls"] = function()
        lspconfig.vtsls.setup({
          root_dir = lspconfig.util.root_pattern(
            ".git",
            "pnpm-workspace.yaml",
            "pnpm-lock.yaml",
            "yarn.lock",
            "package-lock.json",
            "bun.lockb"
          ),
          settings = {
            typescript = {
              preferences = {
                importModuleSpecifier = "relative",
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
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
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
          experimental = {
            completion = {
              entriesLimit = 10,
            },
          },
        })
      end,

      -- Custom configuration for Lua
      ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
            },
          },
        })
      end,
    })
  end,
}