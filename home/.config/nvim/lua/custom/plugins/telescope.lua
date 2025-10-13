return {
  {
    'nvim-telescope/telescope.nvim',
    cmd = 'Telescope',
    version = false,
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'kkharji/sqlite.lua',
      'nvim-telescope/telescope-frecency.nvim',
      'debugloop/telescope-undo.nvim',
      'isak102/telescope-git-file-history.nvim',
    },
    config = function()
      local telescope = require 'telescope'
      local actions = require 'telescope.actions'
      local trouble = require 'trouble.sources.telescope'
      local icons = require 'config.icons'

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'TelescopeResults',
        callback = function(ctx)
          vim.api.nvim_buf_call(ctx.buf, function()
            vim.fn.matchadd('TelescopeParent', '\t\t.*$')
            vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
          end)
        end,
      })

      local function formattedName(_, path)
        local tail = vim.fs.basename(path)
        local parent = vim.fs.dirname(path)
        if parent == '.' then
          return tail
        end
        return string.format('%s\t\t%s', tail, parent)
      end

      telescope.setup {
        file_ignore_patterns = { '%.git/.' },
        defaults = {
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-t>'] = trouble.open,
            },
            n = { ['<C-t>'] = trouble.open },
          },
          previewer = false,
          prompt_prefix = ' ' .. icons.ui.Telescope .. ' ',
          selection_caret = icons.ui.BoldArrowRight .. ' ',
          file_ignore_patterns = { 'node_modules', 'package-lock.json' },
          initial_mode = 'insert',
          sorting_strategy = 'ascending',
          color_devicons = true,
          set_env = { ['COLORTERM'] = 'truecolor' },
          layout_config = {
            prompt_position = 'top',
            preview_cutoff = 120,
          },
          -- Disable dynamic preview which might cause cursor jumping
          dynamic_preview_title = false,
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob=!.git/',
          },
        },
        pickers = {
          find_files = {
            previewer = false,
            layout_config = {
              height = 0.4,
              prompt_position = 'top',
            },
            hidden = true,
          },
          git_files = {
            previewer = false,
            layout_config = {
              height = 0.4,
              prompt_position = 'top',
            },
            hidden = true,
          },
        live_grep = {
          -- Remove debounce completely to test
        },
          grep_string = {
            previewer = true,
          },
          buffers = {
            mappings = {
              i = {
                ['<c-d>'] = actions.delete_buffer,
              },
              n = {
                ['<c-d>'] = actions.delete_buffer,
              },
            },
            previewer = false,
            initial_mode = 'normal',
            layout_config = {
              height = 0.4,
              width = 0.6,
              prompt_position = 'top',
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
          },
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {
              previewer = false,
              initial_mode = 'normal',
              sorting_strategy = 'ascending',
              layout_strategy = 'horizontal',
              layout_config = {
                horizontal = {
                  width = 0.5,
                  height = 0.4,
                  preview_width = 0.6,
                },
              },
            },
          },
          frecency = {
            default_workspace = 'CWD',
            show_scores = true,
            show_unindexed = true,
            disable_devicons = false,
            ignore_patterns = {
              '*.git/*',
              '*/tmp/*',
              '*/lua-language-server/*',
            },
          },
        },
      }
      local function safe_load(ext)
        local ok, err = pcall(telescope.load_extension, ext)
        if not ok then
          if ext == 'fzf' and vim.fn.executable('make') == 1 then
            -- Attempt to (re)build fzf-native automatically if missing
            local fzf_root = vim.fn.stdpath('data') .. '/lazy/telescope-fzf-native.nvim'
            if vim.loop.fs_stat(fzf_root .. '/Makefile') and not vim.loop.fs_stat(fzf_root .. '/build/libfzf.so') then
              vim.fn.system({'make'}, fzf_root)
              ok = pcall(telescope.load_extension, ext)
              if ok then return end
            end
          end
          vim.schedule(function()
            vim.notify(('telescope: failed to load extension %s: %s'):format(ext, err), vim.log.levels.WARN)
          end)
        end
      end

      safe_load 'fzf'
      safe_load 'ui-select'
      safe_load 'frecency'
      safe_load 'undo'
      safe_load 'git_file_history'
    end,
    keys = {
      -- Keep these for now, but you can remove them if you prefer Snacks entirely
      -- { '<leader>ff', '<cmd>Telescope git_files<cr>', desc = 'Find files' },
      -- { '<leader>fa', '<cmd>Telescope find_files<cr>', desc = 'Find all files' },
      -- { '<leader>fi', '<cmd>Telescope live_grep<cr>', desc = 'Find in files' },
    },
  },
}
