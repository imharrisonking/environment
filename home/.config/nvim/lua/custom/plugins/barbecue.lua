return {
    'utilyre/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    dependencies = {
        'SmiteshP/nvim-navic',
        'nvim-tree/nvim-web-devicons', -- optional dependency
    },
    config = function()
        -- Hook into barbecue's update function before setup to avoid duplicate field warning
        local barbecue_ui = require 'barbecue.ui'
        local original_update = barbecue_ui.update

        local base_kind_icons = {
            File = '󰈙',
            Module = '󰏗',
            Namespace = '󰌗',
            Package = '󰏖',
            Class = '󰌗',
            Method = '󰆧',
            Property = '󰜢',
            Field = '󰜢',
            Constructor = '󰆧',
            Enum = '󰕘',
            Interface = '󰕘',
            Function = '󰊕',
            Variable = '󰀫',
            Constant = '󰏿',
            String = '󰀬',
            Number = '󰎠',
            Boolean = '◩',
            Array = '󰅪',
            Object = '󰅩',
            Key = '󰌋',
            Null = '󰟢',
            EnumMember = '󰕘',
            Struct = '󰌗',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰊄',
        }

        local function build_kind_icons(spaced)
            local icons = {}
            for kind, icon in pairs(base_kind_icons) do
                icons[kind] = spaced and (icon .. ' ') or icon
            end
            return icons
        end

        -- Always keep a trailing space so icon + symbol name are readable.
        local kind_icons = build_kind_icons(true)

        local ok_navic, navic = pcall(require, 'nvim-navic')

        local function hl_fg(group)
            local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
            if ok and hl and hl.fg then
                return string.format('#%06x', hl.fg)
            end
        end

        local function theme_colors()
            return {
                text = hl_fg 'Normal' or '#ffffff',
                -- Prefer hint/info blue-ish theme colors for modified indicator (M)
                git_change = hl_fg 'DiagnosticHint'
                    or hl_fg 'DiagnosticInfo'
                    or hl_fg 'Directory'
                    or hl_fg 'Function'
                    or hl_fg 'GitSignsChange'
                    or hl_fg 'DiffChange'
                    or hl_fg 'Changed'
                    or '#7aa2f7',
                git_add = hl_fg 'GitSignsAdd' or hl_fg 'DiffAdd' or hl_fg 'Added' or '#666E40',
            }
        end

        if ok_navic then
            navic.setup {
                icons = kind_icons,
            }
        end

        require('barbecue').setup {
            create_autocmd = false, -- prevent barbecue from updating itself automatically
            kinds = kind_icons,
        }

        -- Keep filename style stable and indicator styles theme-aware
        local function update_barbecue_colors()
            local colors = theme_colors()
            vim.api.nvim_set_hl(0, 'barbecue_basename', { fg = colors.text, bold = true })
            vim.api.nvim_set_hl(0, 'GitChangeIndicator', { fg = colors.git_change, bold = true })
            vim.api.nvim_set_hl(0, 'GitAddIndicator', { fg = colors.git_add, bold = true })
        end

        -- Set up highlight autocmds
        vim.api.nvim_create_autocmd('ColorScheme', {
            group = vim.api.nvim_create_augroup('barbecue_colors', { clear = true }),
            callback = update_barbecue_colors,
        })

        -- Apply colors immediately
        update_barbecue_colors()

        -- Function to add git status to winbar after barbecue filename
        local function update_winbar_git_status()
            local bufnr = vim.api.nvim_get_current_buf()
            local current_file = vim.fn.expand '%'
            local git_status = vim.b[bufnr] and vim.b[bufnr].gitsigns_status_dict
            local has_modified = false
            local has_added = false

            -- Check if file is untracked (completely new file)
            local is_untracked = current_file ~= ''
                and vim.fn.system('git ls-files --others --exclude-standard ' .. vim.fn.shellescape(current_file)):match '%S'

            if is_untracked then
                -- 'A' is reserved for brand-new/untracked files
                has_added = true
            elseif git_status then
                -- 'M' is any tracked-file modification (added/changed/removed hunks)
                has_modified = (git_status.changed and git_status.changed > 0)
                    or (git_status.added and git_status.added > 0)
                    or (git_status.removed and git_status.removed > 0)
                    or false
            end

            local indicator_parts = {}
            if has_modified then
                table.insert(indicator_parts, ' %#GitChangeIndicator#M%*')
            end
            if has_added then
                table.insert(indicator_parts, ' %#GitAddIndicator#A%*')
            end
            local git_indicators = table.concat(indicator_parts, '')

            -- Get current winbar (barbecue) and insert git status after filename
            local current_winbar = vim.wo.winbar or ''

            -- Replace any previously injected indicator segment right before close marker.
            -- Use function replacement so `%#...#` highlight markers are preserved literally.
            local modified_winbar = current_winbar:gsub('(%%#barbecue_basename#[^%%]+)(.-)(%%X%%#barbecue_normal#)', function(basename, _, close)
                -- Barbecue can leave a transient trailing space after basename during
                -- command-line mode redraws (e.g. when pressing `:`). Trim it so the
                -- filename/indicator gap doesn't "jump".
                local clean_basename = basename:gsub('%s+$', '')
                return clean_basename .. git_indicators .. '%#barbecue_normal#' .. close
            end)
            if modified_winbar ~= current_winbar then
                vim.wo.winbar = modified_winbar
            end
        end

        -- Override barbecue's update function to always preserve git status
        local function custom_barbecue_update()
            -- Let barbecue update normally
            original_update()

            -- Always re-add git status after barbecue updates
            vim.schedule(function()
                update_winbar_git_status()
            end)
        end

        -- Assign our custom function to barbecue's update
        barbecue_ui.update = custom_barbecue_update

        -- Barbecue updater for colors and indicator injection
        vim.api.nvim_create_autocmd({
            'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
            'BufWinEnter',
            'CursorHold',
            'InsertLeave',
            'DiagnosticChanged',

            -- include this if you have set `show_modified` to `true`
            -- "BufModifiedSet",
        }, {
            group = vim.api.nvim_create_augroup('barbecue.updater', {}),
            callback = function()
                update_barbecue_colors()
                barbecue_ui.update()
            end,
        })

        -- Separate autocmd for git status - only on meaningful events
        vim.api.nvim_create_autocmd({
            'BufWritePost', -- After saving file (when git status actually changes)
            'BufWinEnter', -- When entering buffer (initial load)
        }, {
            group = vim.api.nvim_create_augroup('barbecue.git_status', {}),
            callback = function()
                vim.defer_fn(update_winbar_git_status, 200)
            end,
        })
    end,
}
