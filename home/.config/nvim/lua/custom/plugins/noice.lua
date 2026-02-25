return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  enabled = true,
  opts = {},
  dependencies = {
    'MunifTanjim/nui.nvim',
    -- "rcarriga/nvim-notify",
  },
  config = function()
    require('noice').setup {
      cmdline = {
        enabled = true,  -- Command palette enabled
        view = 'cmdline_popup',
        opts = {
          position = {
            row = '50%',
            col = '50%',
          },
          size = {
            width = 'auto',
            height = 'auto',
          },
          border = {
            style = 'rounded',
            padding = { 0, 1 },
          },
          win_options = {
            winblend = 0,
          },
        },
        format = {
          cmdline = { pattern = '^:', icon = '>', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = '🔎', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = '🔎', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '$', lang = 'bash' },
          lua = { pattern = '^:%s*lua%s+', icon = '🌙', lang = 'lua' },
          help = { pattern = '^:%s*h%s+', icon = '📚' },
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
        hover = {
          silent = true,
        },
      },
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      -- Add keymaps for better cmdline control
      keys = {
        -- Dismiss cmdline/notifications on Escape
        {
          '<Esc>',
          function()
            if require('noice.lsp').hover.open() then
              require('noice.lsp').hover.close()
            end
          end,
          mode = 'n',
          desc = 'Dismiss notifications',
        },
      },
    }
  end,
}
