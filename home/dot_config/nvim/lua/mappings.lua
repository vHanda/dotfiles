require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("t", "<ESC><ESC>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

