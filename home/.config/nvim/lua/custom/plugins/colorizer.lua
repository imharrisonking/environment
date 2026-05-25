return {
    'catgoose/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
        require('colorizer').setup {
            '*',
            css = { rgb_fn = true },
        }
    end,
}
