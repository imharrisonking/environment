-- Custom color overrides
local M = {}

function M.setup()
  -- Set up autocommand to apply custom highlights after colorscheme loads
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("CustomColors", { clear = true }),
    callback = function()
      -- Use vim.schedule to ensure highlights are applied after everything is loaded
      vim.schedule(function()
        -- Safe highlight retrieval with fallbacks
        local function safe_get_hl(name, fallback)
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
          if ok and hl and type(hl) == 'table' then
            return hl
          end
          return fallback or {}
        end
        
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
      end)
    end,
  })
  
  -- Apply immediately if colorscheme is already loaded
  if vim.g.colors_name then
    vim.schedule(function()
      vim.api.nvim_exec_autocmds("ColorScheme", {})
    end)
  end
end

return M