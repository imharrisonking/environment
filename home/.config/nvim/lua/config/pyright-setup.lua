-- Auto-create pyrightconfig.json for Python projects
vim.api.nvim_create_user_command('PyrightSetup', function()
  local cwd = vim.fn.getcwd()
  local config_path = cwd .. '/pyrightconfig.json'
  
  -- Check if .venv exists
  if vim.fn.isdirectory(cwd .. '/.venv') == 0 then
    print('No .venv directory found. Run "uv venv" first.')
    return
  end
  
  -- Check if config already exists
  if vim.fn.filereadable(config_path) == 1 then
    print('pyrightconfig.json already exists')
    return
  end
  
  local config = {
    exclude = {".venv", "node_modules"},
    venvPath = ".",
    venv = ".venv",
    reportUnusedCallResult = false,
    reportUnknownMemberType = false,
    reportMissingImports = "error",
    typeCheckingMode = "basic"
  }
  
  local json = vim.fn.json_encode(config)
  vim.fn.writefile(vim.split(json, '\n'), config_path)
  print('Created pyrightconfig.json')
end, { desc = 'Create pyrightconfig.json for current project' })