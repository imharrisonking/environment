-- Custom color overrides
local M = {}

local transparent_background = false
local cached_backgrounds = {}

local transparent_groups = {
  'Normal',
  'NormalNC',
  'NormalFloat',
  'FloatBorder',
  'FloatTitle',
  'SignColumn',
  'LineNr',
  'CursorLineNr',
  'EndOfBuffer',
  'StatusLine',
  'StatusLineNC',
  'WinSeparator',
  'VertSplit',
}

local function safe_get_hl(name, fallback)
  local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and hl and type(hl) == 'table' then
    return hl
  end
  return fallback or {}
end

local function cache_backgrounds()
  cached_backgrounds = {}

  for _, group in ipairs(transparent_groups) do
    local hl = safe_get_hl(group, {})
    if hl.bg ~= nil or hl.ctermbg ~= nil then
      cached_backgrounds[group] = {
        bg = hl.bg,
        ctermbg = hl.ctermbg,
      }
    end
  end
end

function M.apply_transparent_background()
  for _, group in ipairs(transparent_groups) do
    local hl = safe_get_hl(group, {})
    hl.bg = 'NONE'
    hl.ctermbg = 'NONE'
    vim.api.nvim_set_hl(0, group, hl)
  end
end

function M.restore_background()
  for _, group in ipairs(transparent_groups) do
    local cached = cached_backgrounds[group]

    if cached then
      local hl = safe_get_hl(group, {})
      hl.bg = cached.bg
      hl.ctermbg = cached.ctermbg
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

function M.toggle_transparent_background()
  transparent_background = not transparent_background

  if transparent_background then
    cache_backgrounds()
    M.apply_transparent_background()
  else
    M.restore_background()
  end

  vim.notify(
    ('Theme background %s'):format(transparent_background and 'off' or 'on'),
    vim.log.levels.INFO
  )
end

function M.setup()
  -- Set up autocommand to apply custom highlights after colorscheme loads
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("CustomColors", { clear = true }),
    callback = function()
      -- Use vim.schedule to ensure highlights are applied after everything is loaded
      vim.schedule(function()
        -- Override cursorline number to use normal text color without bold
        local normal_hl = safe_get_hl("Normal", { fg = "#ffffff" })
        local cursorline_hl = safe_get_hl("CursorLine", { bg = "NONE" })
        
        vim.api.nvim_set_hl(0, "CursorLineNr", {
          fg = normal_hl.fg,
          bg = cursorline_hl.bg,
          bold = false,
        })
        
        -- Force remove italics from import-related highlight groups
        -- This needs to be done after colorscheme loads to override theme settings
        local import_groups = {
          "@module",
          "@module.python", 
          "@variable.module",
          "@lsp.type.namespace",
          "@lsp.type.namespace.python",
          "@lsp.type.module",
          "@lsp.type.module.python",
        }
        
        for _, group in ipairs(import_groups) do
          local current_hl = safe_get_hl(group, {})
          if current_hl.fg then
            vim.api.nvim_set_hl(0, group, {
              fg = current_hl.fg,
              bg = current_hl.bg,
              italic = false,
            })
          end
        end

        -- Set cursor colors to match text color with base background
        local normal_hl = safe_get_hl("Normal", { fg = "#ebdbb2" })
        local base_color = "#1d2021" -- colors.base from mocha theme
        
        vim.api.nvim_set_hl(0, "Cursor", {
          fg = base_color,
          bg = normal_hl.fg,
        })
        
        vim.api.nvim_set_hl(0, "nCursor", {
          fg = base_color,
          bg = normal_hl.fg,
        })
        
        vim.api.nvim_set_hl(0, "vCursor", {
          fg = base_color,
          bg = normal_hl.fg,
        })
        
        vim.api.nvim_set_hl(0, "iCursor", {
          fg = base_color,
          bg = normal_hl.fg,
        })

        if transparent_background then
          cache_backgrounds()
          M.apply_transparent_background()
        end
      end)
    end,
  })

  vim.keymap.set('n', '<leader>uB', M.toggle_transparent_background, {
    desc = 'Toggle Theme Background',
  })
  
  -- Apply immediately if colorscheme is already loaded
  if vim.g.colors_name then
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("ColorScheme", {})
    end)
  end
end

return M
