require "nvchad.options"

-- add yours here!

local o = vim.o
local opt = vim.opt

-- Enable system clipboard integration
opt.clipboard = "unnamedplus"

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
