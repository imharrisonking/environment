-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader><tab>', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- Show hidden files as visible
        hide_dotfiles = false, -- Don't hide dotfiles
        hide_gitignored = false, -- Show gitignored files
        hide_hidden = false, -- Don't hide hidden files (Windows)
      },
      window = {
        mappings = {
          ['<leader><tab>'] = 'close_window',
        },
      },
    },
  },
}
