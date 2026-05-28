return {
    {
        'Myzel394/easytables.nvim',
        ft = 'markdown',
        cmd = {
            'EasyTablesCreateNew',
            'EasyTablesImportThisTable',
        },
        keys = {
            {
                '<leader>on',
                function()
                    local size = vim.fn.input 'Table size (e.g. 3x4, 5, 4x, x6): '
                    if size ~= nil and size ~= '' then
                        vim.cmd('EasyTablesCreateNew ' .. size)
                    end
                end,
                desc = 'Obsidian table: new',
                ft = 'markdown',
            },
            {
                '<leader>oi',
                '<cmd>EasyTablesImportThisTable<CR>',
                desc = 'Obsidian table: import',
                ft = 'markdown',
            },
        },
        config = function()
            require('easytables').setup {}
        end,
    },
}
