require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("t", "<ESC>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<S-ESC>", [[<ESC>]], { desc = "Send ESC to terminal" })

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

--
-- Open from git diff
--

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(ev)
		local buf = ev.buf
		local function open_diff_file()
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local row = vim.api.nvim_win_get_cursor(0)[1]

			local function strip_ansi(s)
				return s:gsub("\27%[[%d;]*[A-Za-z]", "")
			end

			-- Parse the precise line number from the current line's number columns
			-- Format: "  20 │  20 │" (context), "     │  23 │" (added), "  20 │     │" (removed)
			local precise_lnum
			local plain_cur = strip_ansi(lines[row])
			local left, right = plain_cur:match("%s*(%d*)%s*│%s*(%d*)%s*│")
			if right and right ~= "" then
				precise_lnum = tonumber(right) -- new-file line number (added/context)
			elseif left and left ~= "" then
				precise_lnum = tonumber(left) -- old-file line number (removed)
			end

			-- Walk backward for the filename from the nearest hunk header
			local file, fallback_lnum
			for i = row, 1, -1 do
				local plain = strip_ansi(lines[i])
				local f, l = plain:match("([%.%w/][^:]*):(%d+):%s")
				if f and l and vim.fn.filereadable(f) == 1 then
					file, fallback_lnum = f, tonumber(l)
					break
				end
			end

			if not file then
				vim.notify("[diff] no file:line found near cursor", vim.log.levels.WARN)
				return
			end

			local lnum = precise_lnum or fallback_lnum

			local current_win = vim.api.nvim_get_current_win()
			local target
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				if win == current_win then
					goto continue
				end
				local cfg = vim.api.nvim_win_get_config(win)
				if cfg.relative ~= "" then
					goto continue
				end -- skip floats
				local bt = vim.bo[vim.api.nvim_win_get_buf(win)].buftype
				if bt == "" then -- regular file buffer
					target = win
					break
				end
				::continue::
			end

			if target then
				vim.api.nvim_set_current_win(target)
			end
			vim.cmd(string.format("edit %s", vim.fn.fnameescape(file)))

			local win = vim.api.nvim_get_current_win()
			vim.schedule(function()
				vim.schedule(function()
					if vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_set_cursor(win, { lnum, 0 })
					end
				end)
			end)
		end

		-- From terminal insert mode (no need to <C-\><C-n> first)
		vim.keymap.set("t", "<C-o>", function()
			vim.cmd("stopinsert")
			open_diff_file()
		end, { buffer = buf, desc = "Open diff file at cursor" })

		-- From normal mode inside the terminal buffer
		vim.keymap.set("n", "<C-o>", open_diff_file, { buffer = buf, desc = "Open diff file at cursor" })
	end,
})

-- We're putting this here instead of in plugins/init.lua as this gets overwritten
-- by the NvimTreeToggle set my NvChad
vim.keymap.set("n", "<C-n>", "<cmd>Neotree toggle<cr>")
