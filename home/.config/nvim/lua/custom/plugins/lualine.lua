return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  lazy = false,
  event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
  config = function()
    local custom_gruvbox = require('lualine.themes.gruvbox')
    custom_gruvbox.normal.c.bg = 'None'
    
    require('lualine').setup {
      options = {
        theme = custom_gruvbox,
        globalstatus = true,
        icons_enabled = true,
        component_separators = '',
        section_separators = '',
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            'diagnostics',
            sources = { 'nvim_lsp' },
            symbols = { 
              error = require("config.icons").diagnostics.Error,
              warn = require("config.icons").diagnostics.Warning,
              info = require("config.icons").diagnostics.Information,
              hint = require("config.icons").diagnostics.Hint,
            },
          },
          {
            'branch',
            icon = require("config.icons").git.Branch,
          },
          {
            function()
              local filetype = vim.bo.filetype
              if filetype == '' then
                return ''
              end

              -- Map filetypes to display names
              local filetype_map = {
                python = 'Python',
                lua = 'Lua',
                javascript = 'JavaScript',
                javascriptreact = 'JavaScript JSX',
                typescript = 'TypeScript',
                typescriptreact = 'TypeScript TSX',
                go = 'Go',
                rust = 'Rust',
                cpp = 'C++',
                c = 'C',
                html = 'HTML',
                css = 'CSS',
                scss = 'SCSS',
                json = 'JSON',
                yaml = 'YAML',
                xml = 'XML',
                markdown = 'Markdown',
                sh = 'Shell',
                bash = 'Bash',
                zsh = 'Zsh',
                vim = 'Vim',
                java = 'Java',
                php = 'PHP',
                ruby = 'Ruby',
                swift = 'Swift',
                kotlin = 'Kotlin',
                dart = 'Dart',
                sql = 'SQL',
              }

              local display_name = filetype_map[filetype] or filetype:gsub('^%l', string.upper)

              if filetype == 'python' then
                local venv = vim.fn.environ()['VIRTUAL_ENV'] or vim.fn.environ()['CONDA_DEFAULT_ENV']
                if venv then
                  local env_name = vim.fn.fnamemodify(venv, ':t')
                  if not vim.g.python_version_cache then
                    local handle = io.popen 'python --version 2>&1'
                    if handle then
                      local result = handle:read '*a'
                      handle:close()
                      vim.g.python_version_cache = result:match 'Python (%d+%.%d+%.%d+)' or ''
                    end
                  end
                  local version = vim.g.python_version_cache
                  if version and version ~= '' then
                    return string.format('%s (%s) %s', display_name, env_name, version)
                  else
                    return string.format('%s (%s)', display_name, env_name)
                  end
                else
                  return string.format('%s (base)', display_name)
                end
              else
                return display_name
              end
            end,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    }
    
    -- Configure statusline behavior for tpipeline
    -- Let tpipeline control the statusline display entirely
    vim.opt.laststatus = 0
    
    -- Hook into lualine after setup to make backgrounds transparent for tpipeline
    vim.defer_fn(function()
      local lualine_config = require('lualine').get_config()
      if lualine_config and lualine_config.options and lualine_config.options.theme then
        local theme = lualine_config.options.theme
        
        -- Make all backgrounds transparent while keeping original colors
        for mode_name, mode in pairs(theme) do
          if type(mode) == 'table' then
            for section_name, section in pairs(mode) do
              if type(section) == 'table' and section.bg then
                section.bg = 'NONE'
              end
            end
          end
        end
        
        -- Refresh lualine with modified theme
        require('lualine').setup(lualine_config)
      end
    end, 100)
  end,
}