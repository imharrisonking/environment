require "nvchad.options"

-- add yours here!

local o = vim.o
local opt = vim.opt

-- Enable system clipboard integration
opt.clipboard = "unnamedplus"

-- Set line height to 1.5 (dynamic based on font size)
if vim.g.neovide then
  vim.g.neovide_line_space = 0.5
else
  -- For terminal Neovim, approximate 1.5x line height
  opt.linespace = 8
end

-- Ensure clipboard works over SSH
if vim.env.SSH_TTY then
  local function paste()
    return vim.split(vim.fn.getreg("+"), "\n")
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end
