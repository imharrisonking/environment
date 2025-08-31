return {
  -- Autotags for HTML/JSX
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  -- Enhanced commenting
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  -- useful when there are embedded languages in certain types of files (e.g. Vue or React)
  { 'joosepalviste/nvim-ts-context-commentstring', lazy = true },

  -- Better UI for vim.ui interfaces
  {
    'stevearc/dressing.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
    config = function()
      require('dressing').setup()
    end,
  },

  -- Find and replace across project
  {
    'windwp/nvim-spectre',
    enabled = true,
    event = 'BufRead',
    keys = {
      {
        '<leader>Rr',
        function()
          require('spectre').open()
        end,
        desc = 'Replace',
      },
      {
        '<leader>Rw',
        function()
          require('spectre').open_visual { select_word = true }
        end,
        desc = 'Replace Word',
      },
      {
        '<leader>Rf',
        function()
          require('spectre').open_file_search()
        end,
        desc = 'Replace Buffer',
      },
    },
  },

  -- Heuristically set buffer options (detects indentation, etc.)
  {
    'tpope/vim-sleuth',
  },

  -- EditorConfig support
  {
    'editorconfig/editorconfig-vim',
  },

  -- Flash - enhanced f/F/t/T motions
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },

  -- Session persistence
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
  },

  -- Additional mini.nvim modules (extends existing mini.nvim config)
  {
    'echasnovski/mini.pairs',
    config = function()
      require('mini.pairs').setup()
    end,
  },

  -- Icons for various UI elements
  {
    'echasnovski/mini.icons',
    enabled = true,
    opts = {},
    lazy = true,
  },

  -- Terminal/file type support
  {
    'fladson/vim-kitty',
  },

  -- Show key presses for demos/learning
  {
    'nvchad/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      timeout = 1,
      maxkeys = 6,
      -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
      position = 'bottom-right',
    },

    keys = {
      {
        '<leader>ut',
        function()
          vim.cmd 'ShowkeysToggle'
        end,
        desc = 'Show key presses',
      },
    },
  },

  -- Breadcrumbs in winbar using LSP symbols
  {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      require('barbecue').setup {
        create_autocmd = false, -- prevent barbecue from updating itself automatically
      }

      -- Function to update barbecue basename color based on diagnostics and git status
      local function update_barbecue_colors()
        local bufnr = vim.api.nvim_get_current_buf()
        local diagnostics = vim.diagnostic.get(bufnr)
        local has_error = false
        local has_warning = false

        -- Check diagnostic severity
        for _, diag in ipairs(diagnostics) do
          if diag.severity == vim.diagnostic.severity.ERROR then
            has_error = true
            break
          elseif diag.severity == vim.diagnostic.severity.WARN then
            has_warning = true
          end
        end

        -- Check git status using gitsigns
        local git_status = vim.b[bufnr].gitsigns_status_dict
        local has_git_changes = false
        local has_git_additions = false

        if git_status then
          has_git_changes = (git_status.changed and git_status.changed > 0)
          has_git_additions = (git_status.added and git_status.added > 0)
        end

        -- Get colors and update barbecue basename highlight
        local ok, colors = pcall(require, 'catppuccin.palettes')
        if ok then
          local palette = colors.get_palette()
          if palette then
            -- Priority order: Error > Warning > Git Modified > Git Added > Normal
            if has_error then
              vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = palette.red })
            elseif has_warning then
              -- Use the actual diagnostic warning color (yellow)
              vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = palette.yellow })
            elseif has_git_changes then
              -- Use custom git change color
              vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = palette.blue })
            elseif has_git_additions then
              -- Use custom git add color
              vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = '#666E40' })
            else
              vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = palette.text })
            end
          end
        end
      end

      -- Set up highlight autocmds
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('barbecue_colors', { clear = true }),
        callback = update_barbecue_colors,
      })

      -- Apply colors immediately
      update_barbecue_colors()

      -- Function to add git status to winbar after barbecue filename
      local function update_winbar_git_status()
        vim.schedule(function()
          local bufnr = vim.api.nvim_get_current_buf()
          local git_status = vim.b[bufnr] and vim.b[bufnr].gitsigns_status_dict
          local git_indicator = ''

          if git_status then
            if git_status.changed and git_status.changed > 0 then
              git_indicator = ' M'
            elseif git_status.added and git_status.added > 0 then
              git_indicator = ' A'
            end
          end

          -- Get current winbar (barbecue) and insert git status after filename
          local current_winbar = vim.wo.winbar or ''

          if git_indicator ~= '' and not string.match(current_winbar, ' [MA]%%X') then
            -- Insert git status after the basename but before %X%#barbecue_normal#
            local modified_winbar = current_winbar:gsub('(%%#barbecue_basename#[^%%]+)(%%X%%#barbecue_normal#)', '%1' .. git_indicator .. '%2')
            if modified_winbar ~= current_winbar then
              vim.wo.winbar = modified_winbar
            end
          elseif git_indicator == '' then
            -- Remove existing git indicators when no git changes
            local cleaned_winbar = current_winbar:gsub(' [MA](%%X)', '%1')
            if cleaned_winbar ~= current_winbar then
              vim.wo.winbar = cleaned_winbar
            end
          end
        end)
      end


      -- Create highlight groups for git indicators
      vim.api.nvim_set_hl(0, 'GitChangeIndicator', { fg = '#4E6A63', bold = true })
      vim.api.nvim_set_hl(0, 'GitAddIndicator', { fg = '#666E40', bold = true })

      vim.api.nvim_create_autocmd({
        'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
        'BufWinEnter',
        'CursorHold',
        'InsertLeave',
        'DiagnosticChanged', -- Update when diagnostics change
        'User', -- For gitsigns events
        'BufWritePost', -- After saving file
        'BufModifiedSet', -- When buffer modification status changes

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup('barbecue.updater', {}),
        callback = function()
          update_barbecue_colors()
          require('barbecue.ui').update()
          -- Add git status after barbecue renders
          vim.defer_fn(update_winbar_git_status, 150)
        end,
      })
    end,
  },
}
