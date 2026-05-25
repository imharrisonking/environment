return {
    { -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {
            indent = {
                char = '▏', -- Thinner line character
            },
            scope = {
                show_start = false,
                show_end = false,
            },
            exclude = {
                buftypes = { 'prompt' },
                filetypes = {
                    'TelescopePrompt',
                    'TelescopeResults',
                    'snacks_picker_input',
                    'snacks_picker_list',
                },
            },
        },
    },
}
