return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            'jvgrootveld/telescope-zoxide',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local telescope = require 'telescope'
            local builtin = require 'telescope.builtin'

            telescope.setup {
                defaults = {
                    preview = {
                        treesitter = false,
                    },
                    border = {
                        prompt = { 1, 1, 1, 1 },
                        results = { 1, 1, 1, 1 },
                        preview = { 1, 1, 1, 1 },
                    },
                    borderchars = {
                        prompt = { ' ', ' ', '─', '│', '│', ' ', '─', '└' },
                        results = { '─', ' ', ' ', '│', '┌', '─', ' ', '│' },
                        preview = { '─', '│', '─', '│', '┬', '┐', '┘', '┴' },
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
                        require('telescope.themes').get_dropdown {},
                    },
                },
                pickers = {
                    colorscheme = {
                        enable_preview = true,
                    },
                    find_files = {
                        hidden = true,
                        find_command = {
                            'rg',
                            '--files',
                            '--glob',
                            '!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}',
                            '--path-separator',
                            '/',
                        },
                    },
                },
            }

            pcall(telescope.load_extension, 'fzf')
            pcall(telescope.load_extension, 'zoxide')
            pcall(telescope.load_extension, 'ui-select')

            -- Keep Telescope-specific maps here
            vim.keymap.set('n', '<leader>fz', ':Telescope zoxide list<CR>', {})

            vim.keymap.set(
                'n',
                '<leader>jk',
                "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
                {}
            )
        end,
    },
}
