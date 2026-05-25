local M = {}

local ns = vim.api.nvim_create_namespace 'picker-debug'
local augroup = vim.api.nvim_create_augroup('picker-debug-events', { clear = true })
local enabled = false
local original_set_cursor = nil

local picker_fts = {
  TelescopePrompt = true,
  TelescopeResults = true,
  snacks_picker_input = true,
  snacks_picker_list = true,
}

local function log_path()
  return vim.fn.stdpath('cache') .. '/picker-debug.log'
end

local function now()
  return os.date('%Y-%m-%d %H:%M:%S')
end

local function in_picker_buf(bufnr)
  local ft = vim.bo[bufnr].filetype
  return picker_fts[ft] == true
end

local function current_state(tag, extra)
  local bufnr = vim.api.nvim_get_current_buf()
  if not in_picker_buf(bufnr) then
    return nil
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  if #line > 120 then
    line = line:sub(1, 120) .. '...'
  end

  local payload = {
    string.format('[%s] %s', now(), tag),
    string.format('  mode=%s bufnr=%d ft=%s bt=%s cursor=(%d,%d)', vim.fn.mode(), bufnr, vim.bo[bufnr].filetype, vim.bo[bufnr].buftype, pos[1], pos[2]),
    string.format('  line=%q', line),
  }

  if extra and extra ~= '' then
    table.insert(payload, '  ' .. extra)
  end

  return payload
end

local function append(lines)
  if not lines then
    return
  end
  vim.fn.writefile(lines, log_path(), 'a')
end

local function short_traceback()
  local tb = debug.traceback('', 3)
  local lines = {}
  for s in tb:gmatch('[^\n]+') do
    table.insert(lines, s)
    if #lines >= 8 then
      break
    end
  end
  return table.concat(lines, ' | ')
end

local function dump_insert_maps()
  local bufnr = vim.api.nvim_get_current_buf()
  local maps = vim.api.nvim_buf_get_keymap(bufnr, 'i')
  local out = { string.format('[%s] BUFFER INSERT MAPS bufnr=%d', now(), bufnr) }
  for _, m in ipairs(maps) do
    table.insert(out, string.format('  lhs=%s rhs=%s expr=%s noremap=%s sid=%s', m.lhs or '', m.rhs or '', tostring(m.expr), tostring(m.noremap), tostring(m.sid)))
  end
  if #maps == 0 then
    table.insert(out, '  (no buffer-local insert maps)')
  end
  append(out)
end

local function dump_global_insert_maps()
  local maps = vim.api.nvim_get_keymap 'i'
  local out = { string.format('[%s] GLOBAL INSERT MAPS', now()) }
  for _, m in ipairs(maps) do
    table.insert(out, string.format('  lhs=%s rhs=%s expr=%s noremap=%s sid=%s', m.lhs or '', m.rhs or '', tostring(m.expr), tostring(m.noremap), tostring(m.sid)))
  end
  if #maps == 0 then
    table.insert(out, '  (no global insert maps)')
  end
  append(out)
end

function M.start()
  if enabled then
    vim.notify('Picker debug already enabled: ' .. log_path(), vim.log.levels.INFO)
    return
  end

  vim.fn.writefile({ string.format('=== Picker debug started %s ===', now()) }, log_path())
  enabled = true

  if not original_set_cursor then
    original_set_cursor = vim.api.nvim_win_set_cursor
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_win_set_cursor = function(win, pos)
      if enabled then
        local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
        if ok and buf and in_picker_buf(buf) then
          append({
            string.format('[%s] nvim_win_set_cursor win=%s pos=(%s,%s)', now(), tostring(win), tostring(pos and pos[1]), tostring(pos and pos[2])),
            '  trace=' .. short_traceback(),
          })
        end
      end
      return original_set_cursor(win, pos)
    end
  end

  vim.on_key(function(key)
    if not enabled then
      return
    end
    local state = current_state('on_key', 'key=' .. vim.fn.keytrans(key))
    append(state)
  end, ns)

  vim.api.nvim_clear_autocmds { group = augroup }
  vim.api.nvim_create_autocmd({ 'InsertCharPre', 'TextChangedI', 'CursorMovedI', 'ModeChanged', 'WinEnter', 'BufEnter' }, {
    group = augroup,
    callback = function(args)
      if not enabled or not in_picker_buf(args.buf) then
        return
      end
      append(current_state('autocmd:' .. args.event))
      if args.event == 'BufEnter' or args.event == 'WinEnter' then
        dump_insert_maps()
        dump_global_insert_maps()
      end
    end,
  })

  vim.notify('Picker debug started. Log: ' .. log_path(), vim.log.levels.INFO)
end

function M.stop()
  if not enabled then
    vim.notify('Picker debug is not enabled', vim.log.levels.INFO)
    return
  end
  enabled = false

  if original_set_cursor then
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_win_set_cursor = original_set_cursor
    original_set_cursor = nil
  end

  vim.on_key(nil, ns)
  vim.api.nvim_clear_autocmds { group = augroup }
  append({ string.format('=== Picker debug stopped %s ===', now()) })
  vim.notify('Picker debug stopped. Log: ' .. log_path(), vim.log.levels.INFO)
end

function M.open_log()
  vim.cmd('edit ' .. vim.fn.fnameescape(log_path()))
end

function M.setup()
  vim.api.nvim_create_user_command('PickerDebugStart', M.start, { desc = 'Start picker key/cursor debug logging' })
  vim.api.nvim_create_user_command('PickerDebugStop', M.stop, { desc = 'Stop picker key/cursor debug logging' })
  vim.api.nvim_create_user_command('PickerDebugOpenLog', M.open_log, { desc = 'Open picker debug log file' })
end

return M
