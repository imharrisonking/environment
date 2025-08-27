require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- System clipboard integration
-- Visual mode: yank to clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
-- Normal mode: yank line to clipboard  
map("n", "<leader>Y", '"+yy', { desc = "Yank line to system clipboard" })
-- Visual and normal mode: paste from clipboard
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
