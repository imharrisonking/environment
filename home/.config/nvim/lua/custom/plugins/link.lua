return {
    {
        'qadzek/link.vim',
        init = function()
            -- link.vim's insert-mode conversion behavior can interfere with
            -- prompt buffers used by picker UIs.
            -- Keep the plugin but disable default mappings globally.
            vim.g.link_use_default_mappings = 0
        end,
    },
}
