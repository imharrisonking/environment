-- Custom color overrides
local M = {}

function M.setup()
  -- Set up autocommand to apply custom highlights after colorscheme loads
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("CustomColors", { clear = true }),
    callback = function()
      -- Override cursorline number to use normal text color without bold
      vim.api.nvim_set_hl(0, "CursorLineNr", {
        fg = vim.api.nvim_get_hl(0, { name = "Normal" }).fg, -- Use normal text color
        bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg, -- Keep cursorline background
        bold = false, -- Remove bold
      })
      
      -- Optionally, you can also make the cursorline background more subtle
      -- Uncomment the line below if you want a very subtle cursorline background
      -- vim.api.nvim_set_hl(0, "CursorLine", { bg = "NONE" })
    end,
  })
  
  -- Apply immediately if colorscheme is already loaded
  if vim.g.colors_name then
    vim.api.nvim_exec_autocmds("ColorScheme", {})
  end
end

return M