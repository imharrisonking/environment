return {
  'nvim-lualine/lualine.nvim',
  enabled = true,
  lazy = false,
  event = { 'BufReadPost', 'BufNewFile', 'VeryLazy' },
  config = function()
    local function make_lualine_backgrounds_transparent()
      local groups = vim.fn.getcompletion('lualine_', 'highlight')
      for _, group in ipairs(groups) do
        -- Some nvim versions reject ctermbg=bg (E420), so guard and fallback.
        local ok = pcall(vim.cmd, 'highlight ' .. group .. ' guibg=bg ctermbg=NONE')
        if not ok then
          vim.cmd('highlight ' .. group .. ' guibg=NONE ctermbg=NONE')
        end
      end
    end

    require('lualine').setup {
      options = {
        theme = 'auto',
        globalstatus = true,
        icons_enabled = true,
        component_separators = '',
        section_separators = '',
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
          refresh_time = 16,
          events = { 'WinEnter', 'BufEnter', 'BufWritePost', 'CursorHold' },
        },
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
                  
                  -- Check for pyvenv.cfg to get the actual project name
                  local pyvenv_cfg = venv .. '/pyvenv.cfg'
                  if vim.fn.filereadable(pyvenv_cfg) == 1 then
                    local lines = vim.fn.readfile(pyvenv_cfg)
                    for _, line in ipairs(lines) do
                      local project_name = line:match('^prompt = "?([^"]*)"?')
                      if project_name then
                        env_name = project_name
                        break
                      end
                    end
                  end
                  
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

    -- Keep lualine/tpipeline bg transparent even after colorscheme changes
    make_lualine_backgrounds_transparent()
    vim.defer_fn(make_lualine_backgrounds_transparent, 50)
    vim.defer_fn(make_lualine_backgrounds_transparent, 200)
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = make_lualine_backgrounds_transparent,
    })
    vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
      callback = make_lualine_backgrounds_transparent,
    })
  end,
}
