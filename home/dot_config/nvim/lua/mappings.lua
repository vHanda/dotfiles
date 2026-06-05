require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("t", "<ESC><ESC>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

--
-- live grep
--
local function get_visual_selection()
	local mode = vim.fn.mode()
	local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode })

	return table.concat(lines, "\n")
end

vim.keymap.del("n", "<leader>fw")
vim.keymap.set("x", "<D-F>", function()
	local text = get_visual_selection()

	require("telescope.builtin").live_grep({
		default_text = text,
	})
end, { desc = "Live grep visual selection" })

vim.keymap.set("n", "<leader>fj", function()
	require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
