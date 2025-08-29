return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "meuter/lualine-so-fancy.nvim",
  },
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    local icons = require("config.icons")
    require("lualine").setup({
      options = {
        theme = "catppuccin",
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = icons.ui.DividerRight, right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {
            "alfa-nvim",
            "help",
            "neo-tree",
            "Trouble",
            "spectre_panel",
            "toggleterm",
          },
          winbar = {},
        },
      },
      sections = {
        lualine_a = {},
        lualine_b = {
          "fancy_branch",
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = {
              modified = "  ",
            },
          },
          { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
          { "fancy_searchcount" },
        },
        lualine_x = {
          "fancy_lsp_servers",
          "fancy_diff",
          {
            function()
              local filetype = vim.bo.filetype
              if filetype == '' then
                return ''
              end
              
              -- Map filetypes to display names
              local filetype_map = {
                python = "Python",
                lua = "Lua",
                javascript = "JavaScript",
                javascriptreact = "JavaScript JSX",
                typescript = "TypeScript",
                typescriptreact = "TypeScript TSX",
                go = "Go",
                rust = "Rust",
                cpp = "C++",
                c = "C",
                html = "HTML",
                css = "CSS",
                scss = "SCSS",
                json = "JSON",
                yaml = "YAML",
                xml = "XML",
                markdown = "Markdown",
                sh = "Shell",
                bash = "Bash",
                zsh = "Zsh",
                vim = "Vim",
                java = "Java",
                php = "PHP",
                ruby = "Ruby",
                swift = "Swift",
                kotlin = "Kotlin",
                dart = "Dart",
                sql = "SQL",
              }
              
              local display_name = filetype_map[filetype] or filetype:gsub("^%l", string.upper)
              
              if filetype == 'python' then
                local venv = vim.fn.environ()["VIRTUAL_ENV"] or vim.fn.environ()["CONDA_DEFAULT_ENV"]
                if venv then
                  local env_name = vim.fn.fnamemodify(venv, ":t")
                  if not vim.g.python_version_cache then
                    local handle = io.popen("python --version 2>&1")
                    if handle then
                      local result = handle:read("*a")
                      handle:close()
                      vim.g.python_version_cache = result:match("Python (%d+%.%d+%.%d+)") or ""
                    end
                  end
                  local version = vim.g.python_version_cache
                  if version and version ~= "" then
                    return string.format("%s |  %s (%s)", display_name, env_name, version)
                  else
                    return string.format("%s |  %s", display_name, env_name)
                  end
                else
                  return string.format("%s |  base", display_name)
                end
              else
                return display_name
              end
            end,
            icon = "",
          },
          "progress",
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "neo-tree", "lazy" },
    })
  end,
}