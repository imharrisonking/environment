-- Integration with the external clang-tidy binary from LLVM.
--
-- Wires up :ClangTidyFix and :ClangTidyCheck commands plus a buffer-local
-- <leader>lF keymap for C-family filetypes. clangd has clang-tidy statically
-- linked for in-editor diagnostics, but the standalone binary is required
-- to bulk-apply --fix across a whole file at once.
--
-- The Homebrew `llvm` formula is keg-only, so it is NOT on $PATH by default.
-- We probe /opt/homebrew/opt/llvm/bin/clang-tidy first, then fall back to a
-- clang-tidy found anywhere on $PATH.

local M = {}

-- Resolve the clang-tidy binary.
local function find_clang_tidy()
    local candidates = {
        '/opt/homebrew/opt/llvm/bin/clang-tidy', -- Apple Silicon Homebrew
        '/usr/local/opt/llvm/bin/clang-tidy', -- Intel Homebrew
    }
    for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
            return candidate
        end
    end
    local on_path = vim.fn.exepath('clang-tidy')
    if on_path ~= '' then
        return on_path
    end
    return nil
end

-- Cache of the macOS SDK sysroot path, populated lazily on first use.
-- Homebrew's clang-tidy is built against LLVM, not Apple Clang, so it does
-- not know where <iostream> and the rest of the macOS system headers live.
-- Without `--extra-arg=-isysroot <sdk>`, clang-tidy errors with
-- "'iostream' file not found" whenever compile_commands.json was produced by
-- Apple Clang (the CMake default on macOS). We probe `xcrun --show-sdk-path`
-- once at first use and stash the result.
local sysroot_cache ---@type string|nil|false  -- false = probed-but-missing

local function get_macos_sysroot()
    if sysroot_cache ~= nil then
        return sysroot_cache or nil
    end
    if vim.loop.os_uname().sysname ~= 'Darwin' then
        sysroot_cache = false
        return nil
    end
    local out = vim.fn.system { 'xcrun', '--show-sdk-path' }
    if vim.v.shell_error == 0 then
        out = out:gsub('^%s+', ''):gsub('%s+$', ''):gsub('[\r\n]', '')
        if out ~= '' and vim.fn.isdirectory(out) == 1 then
            sysroot_cache = out
            return out
        end
    end
    sysroot_cache = false
    return nil
end

-- Walk upward from the buffer file to find compile_commands.json.
-- Returns the directory containing it (suitable for clang-tidy's -p flag).
local function find_compile_db(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == '' then
        return nil, nil
    end
    local start_dir = vim.fs.dirname(file)
    if not start_dir then
        return nil, nil
    end
    local db = vim.fs.find({ 'compile_commands.json' }, {
        upward = true,
        path = start_dir,
        type = 'file',
    })[1]
    if db then
        return vim.fs.dirname(db), db
    end
    return nil, nil
end

-- Walk upward from the buffer file to find a project-local .clang-tidy config.
-- Returns the path to the file if found.
local function find_clang_tidy_config(bufnr)
    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == '' then
        return nil
    end
    local start_dir = vim.fs.dirname(file)
    if not start_dir then
        return nil
    end
    return vim.fs.find({ '.clang-tidy' }, {
        upward = true,
        path = start_dir,
        type = 'file',
    })[1]
end

-- Parse clang-tidy diagnostic lines into quickfix entries.
-- Format: <path>:<line>:<col>: <kind>: <message> [<check-name>]
local function parse_diagnostics(output)
    local qf = {}
    for line in output:gmatch '[^\r\n]+' do
        local path, lnum, col, kind, msg, check = line:match
            '^([^:]+):(%d+):(%d+):%s*(%w+):%s*(.-)%s*%[([^%]]*)%]%s*$'
        if path and lnum then
            kind = kind:lower()
            if kind == 'warning' or kind == 'error' then
                local text = msg
                if check and check ~= '' then
                    text = msg .. ' [' .. check .. ']'
                end
                table.insert(qf, {
                    filename = path,
                    lnum = tonumber(lnum),
                    col = tonumber(col),
                    text = text,
                    type = kind == 'error' and 'E' or 'W',
                })
            end
        end
    end
    return qf
end

-- Run clang-tidy asynchronously on the given buffer.
-- When `fix` is true, --fix is passed; otherwise it is a dry-run report.
local function run(bufnr, fix)
    bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    local file = vim.api.nvim_buf_get_name(bufnr)
    if file == '' then
        vim.notify('ClangTidy: buffer has no filename — save it first', vim.log.levels.ERROR)
        return
    end

    local clang_tidy = find_clang_tidy()
    if not clang_tidy then
        vim.notify(
            'ClangTidy: clang-tidy binary not found.\n'
                .. 'Install LLVM: `brew install llvm`\n'
                .. '(keg-only — I look at /opt/homebrew/opt/llvm/bin/clang-tidy first).',
            vim.log.levels.ERROR
        )
        return
    end

    -- clang-tidy reads from disk, so save any unsaved buffer content first.
    if vim.bo[bufnr].modified then
        local write_err
        vim.api.nvim_buf_call(bufnr, function()
            local ok, e = pcall(function()
                vim.cmd 'noautocmd silent! write'
            end)
            if not ok then
                write_err = e
            end
        end)
        if write_err then
            vim.notify('ClangTidy: cannot write buffer — ' .. tostring(write_err), vim.log.levels.ERROR)
            return
        end
    end

    local db_dir, db_path = find_compile_db(bufnr)
    local local_config = find_clang_tidy_config(bufnr)

    -- Build the clang-tidy command.
    -- --allow-no-checks avoids a hard failure ("no checks enabled") when no
    -- .clang-tidy config is reachable from the source file at all.
    local args = { clang_tidy, '--allow-no-checks', file }
    if fix then
        table.insert(args, '--fix')
        table.insert(args, '--format-style=file')
    else
        table.insert(args, '--warnings-as-errors=*')
    end
    -- If no project-local .clang-tidy was found by walking up, fall back to
    -- the user's global ~/.clang-tidy so fix behaviour matches what clangd
    -- reports in the editor.
    if not local_config then
        local home_config = vim.env.HOME and (vim.env.HOME .. '/.clang-tidy') or nil
        if home_config and vim.fn.filereadable(home_config) == 1 then
            table.insert(args, '--config-file=' .. home_config)
        end
    end
    if db_dir then
        table.insert(args, '-p')
        table.insert(args, db_dir)
    end

    -- On macOS, Homebrew's clang-tidy is LLVM-based and doesn't know where
    -- Apple's SDK headers live. Without `-isysroot`, clang-tidy fails with
    -- `error: 'iostream' file not found` whenever compile_commands.json
    -- was produced by Apple Clang (CMake's default toolchain on macOS).
    -- Pass the macOS SDK path through as extra-arg so the headers resolve.
    local sysroot = get_macos_sysroot()
    if sysroot then
        table.insert(args, '--extra-arg=-isysroot')
        table.insert(args, '--extra-arg=' .. sysroot)
    end

    local footer = db_path and ('using ' .. vim.fs.basename(db_path))
        or 'no compile_commands.json — header-dependent checks will be limited'
    vim.notify(
        'ClangTidy: running on '
            .. vim.fs.basename(file)
            .. (fix and ' (--fix, ' or ' (check, ')
            .. footer
            .. ')',
        vim.log.levels.INFO
    )

    -- Run async so the editor never blocks on the (slow) clang-tidy invocation.
    vim.system(args, { text = true }, function(result)
        local combined = (result.stdout or '') .. (result.stderr or '')

        vim.schedule(function()
            -- Reload buffer from disk so --fix changes are visible.
            if fix and vim.api.nvim_buf_is_valid(bufnr) then
                vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd 'noautocmd silent! checktime'
                end)
            end

            -- Populate the quickfix list with whatever clang-tidy reported.
            local qf = parse_diagnostics(combined)
            if #qf > 0 then
                vim.fn.setqflist({}, 'r', {
                    title = 'clang-tidy ' .. (fix and '(--fix)' or '(check)'),
                    items = qf,
                })
                vim.cmd 'botright copen'
            else
                vim.cmd 'cclose'
            end

            -- Surface a summary notification.
            local fixed_note = ''
            if fix then
                local n = combined:match '(%d+) fixes? applied'
                if n then
                    fixed_note = ' (' .. n .. ' fixes applied)'
                end
            end

            if result.code == 0 then
                vim.notify(
                    'ClangTidy: clean (' .. (fix and 'fix run' or 'check') .. ')' .. fixed_note,
                    vim.log.levels.INFO,
                    { title = 'clang-tidy' }
                )
            else
                local count = #qf
                local level = count > 0 and vim.log.levels.WARN or vim.log.levels.ERROR
                vim.notify(
                    'ClangTidy: '
                        .. count
                        .. ' issue(s)'
                        .. (fix and ', fixes applied if possible' or '')
                        .. fixed_note
                        .. ' [exit '
                        .. tostring(result.code)
                        .. ']',
                    level,
                    { title = 'clang-tidy' }
                )
            end
        end)
    end)
end

function M.setup()
    vim.api.nvim_create_user_command('ClangTidyFix', function()
        run(0, true)
    end, {
        desc = 'Run clang-tidy --fix on the current C/C++ buffer',
        nargs = 0,
        bar = true,
    })

    vim.api.nvim_create_user_command('ClangTidyCheck', function()
        run(0, false)
    end, {
        desc = 'Run clang-tidy (no fix) and populate the quickfix list',
        nargs = 0,
        bar = true,
    })

    -- Buffer-local keymaps, registered only in C-family filetypes so they
    -- don't collide with anything elsewhere in the config.
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('clang-tidy-keymap', { clear = true }),
        pattern = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'cuda-cpp' },
        desc = 'Bind <leader>lF / <leader>lT to ClangTidy in C-family buffers',
        callback = function(args)
            vim.keymap.set('n', '<leader>lF', function()
                run(args.buf, true)
            end, { buffer = args.buf, desc = 'ClangTidy: Apply --fix to buffer' })
            vim.keymap.set('n', '<leader>lT', function()
                run(args.buf, false)
            end, { buffer = args.buf, desc = 'ClangTidy: Check buffer (dry-run)' })
        end,
    })
end

return M