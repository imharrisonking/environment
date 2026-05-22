return {
    -- Session persistence
    {
        'folke/persistence.nvim',
        event = 'BufReadPre', -- this will only start session saving when an actual file was opened
        opts = {},
    },

    -- Terminal/file type support
    {
        'fladson/vim-kitty',
    },
}
