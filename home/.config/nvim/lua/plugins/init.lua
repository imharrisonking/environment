return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Additional options 
  {
    require("configs.options")
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "pyright",     -- Python
                "tsserver",    -- TypeScript/JavaScript
                "marksman",    -- Markdown
                "ocamllsp",    -- OCaml/mdoc
                "gopls",       -- Go
                "clangd",      -- C/C++
            },
        },
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },  -- Fixed org name
            "neovim/nvim-lspconfig",
        },
    },

  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css", "typescript", "python"
  		},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
      }
  	},
  },
}

