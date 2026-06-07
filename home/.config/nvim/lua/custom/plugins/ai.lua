local function set_copilot_enabled(enabled)
    if enabled then
        vim.cmd 'Copilot enable'
    else
        vim.cmd 'Copilot disable'
    end

    vim.g.copilot_enabled = enabled
    vim.notify('Copilot ' .. (enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

local function toggle_copilot()
    local current = vim.g.copilot_enabled
    if current == nil then
        current = true
    end
    set_copilot_enabled(not current)
end

return {
    {
        'zbirenbaum/copilot.lua',
        enabled = true,
        cmd = 'Copilot',
        build = ':Copilot auth',
        event = 'InsertEnter',
        keys = {
            {
                '<leader>ua',
                toggle_copilot,
                desc = 'Toggle Copilot AI',
            },
        },
        config = function()
            require('copilot').setup {
                panel = {
                    enabled = true,
                    auto_refresh = false,
                    keymap = {
                        jump_next = '<c-j>',
                        jump_prev = '<c-k>',
                        accept = '<CR>',
                        refresh = 'r',
                        open = '<M-CR>',
                    },
                    layout = {
                        position = 'bottom', -- | top | left | right
                        ratio = 0.4,
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 100,
                    keymap = {
                        accept = '<C-a>',
                        accept_word = false,
                        accept_line = false,
                        next = '<M-]>',
                        prev = '<M-[>',
                        dismiss = '<C-e>',
                    },
                },
                filetypes = {
                    cpp = false,
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ['.'] = false,
                },
            }

            -- Default on; allows runtime toggling via <leader>ua
            vim.g.copilot_enabled = true
        end,
    },
}
