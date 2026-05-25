local M = {}

function M.copyFilePathAndLineNumber()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('No file path available for current buffer', vim.log.levels.WARN)
    return
  end

  local line = vim.api.nvim_win_get_cursor(0)[1]
  local text = string.format('%s:%d', file, line)
  vim.fn.setreg('+', text)
  vim.notify('Copied: ' .. text, vim.log.levels.INFO)
end

function M.toggle_go_test()
  local file = vim.fn.expand '%:t'
  local alt

  if file:match '_test%.go$' then
    alt = file:gsub('_test%.go$', '.go')
  elseif file:match '%.go$' then
    alt = file:gsub('%.go$', '_test.go')
  else
    vim.notify('Not a Go file', vim.log.levels.WARN)
    return
  end

  vim.cmd('edit ' .. vim.fn.fnameescape(vim.fn.expand('%:h') .. '/' .. alt))
end

function M.get_highlighted_line_numbers()
  local start_line = vim.fn.line "'<"
  local end_line = vim.fn.line "'>"

  if start_line <= 0 or end_line <= 0 then
    vim.notify('No visual selection found', vim.log.levels.WARN)
    return
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local numbers = {}
  for i = start_line, end_line do
    table.insert(numbers, tostring(i))
  end

  local text = table.concat(numbers, ',')
  vim.fn.setreg('+', text)
  vim.notify('Copied line numbers: ' .. text, vim.log.levels.INFO)
  return text
end

return M
