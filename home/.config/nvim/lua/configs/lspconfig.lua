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

        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
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