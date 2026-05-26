-- return {}
return {
    -- dir = "~/dotfiles/.config/nvim/lua/plugins/mdmath.nvim",
    'Thiago4532/mdmath.nvim',
    enabled = function()
        -- mdmath requires external binaries + Kitty graphics support.
        -- If requirements are missing, disable it to avoid startup errors in markdown buffers.
        local has_node = vim.fn.executable 'node' == 1
        local has_npm = vim.fn.executable 'npm' == 1
        local has_rsvg = vim.fn.executable 'rsvg-convert' == 1
        local has_magick = vim.fn.executable 'magick' == 1 or vim.fn.executable 'convert' == 1
        local term = vim.env.TERM or ''
        local term_program = vim.env.TERM_PROGRAM or ''
        local has_kitty = vim.env.KITTY_WINDOW_ID ~= nil or term:find('kitty', 1, true) ~= nil
        local has_ghostty = term_program:find('ghostty', 1, true) ~= nil or term:find('ghostty', 1, true) ~= nil

        return has_node and has_npm and has_rsvg and has_magick and (has_kitty or has_ghostty)
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        filetypes = { 'markdown' },
        foreground = 'Normal',
        anticonceal = true,
        hide_on_insert = true,
        dynamic = true,
        dynamic_scale = 0.5,
        update_interval = 400,

        -- Internal scale of the equation images, increase to prevent blurry images when increasing terminal
        -- font, high values may produce aliased images.
        -- WARNING: This do not affect how the images are displayed, only how many pixels are used to render them.
        --          See `dynamic_scale` to modify the displayed size.
        -- internal_scale = 1.0,
    },
    config = function(_, opts)
        require('mdmath').setup(opts)

        vim.api.nvim_create_user_command('MdMathCheck', function()
            local term = vim.env.TERM or ''
            local term_program = vim.env.TERM_PROGRAM or ''
            local checks = {
                { name = 'node', ok = vim.fn.executable 'node' == 1 },
                { name = 'npm', ok = vim.fn.executable 'npm' == 1 },
                { name = 'rsvg-convert', ok = vim.fn.executable 'rsvg-convert' == 1 },
                { name = 'imagemagick (magick|convert)', ok = vim.fn.executable 'magick' == 1 or vim.fn.executable 'convert' == 1 },
                {
                    name = 'terminal (kitty|ghostty)',
                    ok = vim.env.KITTY_WINDOW_ID ~= nil
                        or term:find('kitty', 1, true) ~= nil
                        or term_program:find('ghostty', 1, true) ~= nil
                        or term:find('ghostty', 1, true) ~= nil,
                },
            }

            local lines = { 'mdmath requirements:' }
            local all_ok = true
            for _, check in ipairs(checks) do
                if not check.ok then
                    all_ok = false
                end
                table.insert(lines, string.format('  %s %s', check.ok and '✓' or '✗', check.name))
            end

            table.insert(lines, string.format('  TERM=%s', term == '' and '<empty>' or term))
            table.insert(lines, string.format('  TERM_PROGRAM=%s', term_program == '' and '<empty>' or term_program))
            table.insert(lines, '')
            table.insert(lines, all_ok and 'mdmath should load.' or 'mdmath may be disabled: missing requirements above.')

            vim.notify(table.concat(lines, '\n'), all_ok and vim.log.levels.INFO or vim.log.levels.WARN)
        end, { desc = 'Check mdmath runtime requirements' })
    end,
}
