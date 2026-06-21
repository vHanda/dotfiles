vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

--
-- Scrolling
--
vim.opt.mouse = "a"
vim.opt.mousescroll = "ver:2,hor:1"
vim.opt.smoothscroll = true
vim.opt.display:append("lastline")

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

--
-- Clipboard
--
if vim.env.SSH_TTY then
  vim.g.clipboard = "osc52"
  vim.opt.clipboard = "unnamedplus"
end

-- Copy clipboard on select in the terminal
local function add_konsole_word_chars(buf)
  -- Konsole default WordCharacters:
  -- : @ - . / _ ~ ? & = % + #
  --
  -- Use numeric ASCII forms for punctuation so Vim's 'iskeyword'
  -- parser does not treat things like @ or - specially.
  local konsole_chars = {
    "58",  -- :
    "64",  -- @ literal
    "45",  -- -
    "46",  -- .
    "47",  -- /
    -- "_" is already in the default iskeyword, but including it is harmless.
    "_",
    "126", -- ~
    "63",  -- ?
    "38",  -- &
    "61",  -- =
    "37",  -- %
    "43",  -- +
    "35",  -- #
  }

  local isk = vim.bo[buf].iskeyword
  local parts = vim.split(isk, ",", { plain = true })
  local seen = {}

  for _, part in ipairs(parts) do
    seen[part] = true
  end

  for _, ch in ipairs(konsole_chars) do
    if not seen[ch] then
      table.insert(parts, ch)
    end
  end

  vim.bo[buf].iskeyword = table.concat(parts, ",")

  -- We could also just have done something like this -
  -- vim.bo[buf].iskeyword = "@,48-57,_,192-255,58,64,45,46,47,126,63,38,61,37,43,35"
end

local function copy_visual_selection_to_clipboard()
  local mode = vim.fn.mode()

  local lines = vim.fn.getregion(
    vim.fn.getpos("v"),
    vim.fn.getpos("."),
    { type = mode }
  )

  vim.fn.setreg("+", lines, mode)
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ev)
    add_konsole_word_chars(ev.buf)

    vim.keymap.set(
      "x",
      "<LeftRelease>",
      "<Cmd>lua copy_visual_selection_to_clipboard()<CR>",
      {
        buffer = ev.buf,
        silent = true,
        desc = "Copy terminal mouse selection to clipboard without leaving visual mode",
      }
    )

    vim.keymap.set(
      "x",
      "<2-LeftRelease>",
      "<Cmd>lua copy_visual_selection_to_clipboard()<CR>",
      {
        buffer = ev.buf,
        silent = true,
        desc = "Copy terminal double-click selection to clipboard",
      }
    )
  end,
})

_G.copy_visual_selection_to_clipboard = copy_visual_selection_to_clipboard


--
-- bootstrap lazy and all plugins
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("autocmds")

vim.schedule(function()
	require("mappings")
end)

--
-- Neovide
--
if vim.g.neovide then
	local is_macos = vim.uv.os_uname().sysname == "Darwin"

	-- Enable save / copy / paste in neovide
	local save_key = is_macos and "<D-s>" or "<C-S-s>"
	local copy_key = is_macos and "<D-c>" or "<C-S-c>"
	local paste_key = is_macos and "<D-v>" or "<C-S-v>"

	local function save()
		vim.cmd.write()
	end
	local function copy()
		vim.cmd([[normal! "+y]])
	end
	local function paste()
		vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
	end

	vim.keymap.set({ "n", "i", "v" }, save_key, save, { desc = "Save" })
	vim.keymap.set("v", copy_key, copy, { silent = true, desc = "Copy" })
	vim.keymap.set({ "n", "i", "v", "c", "t" }, paste_key, paste, { silent = true, desc = "Paste" })

	-- Custom Options
	vim.g.neovide_cursor_animation_length = 0.03
	vim.g.neovide_cursor_short_animation_length = 0.01
	vim.o.guifont = "JetBrainsMono Nerd Font Mono:h12"

	-- Scrolling
	vim.g.neovide_scroll_animation_length = 0.08
end

-- Beancount
vim.filetype.add({
	extension = {
		beancount = "beancount",
		bean = "beancount",
	},
})

-- NvChad themes seem to overwrite the terminal colors
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		for i = 0, 15 do
			vim.g["terminal_color_" .. i] = nil
		end
	end,
})

-- Custom UI stuff (Ctrl + K)
vim.o.winborder = "rounded"

-- Flutter
require("flutter-tools").setup({})

-- Terminal Horizontal scrolling is weird
-- Maybe this should be set globally?
vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})

-- Visual WhiteSpace theme
vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#5D5F71", bg = "#24282d" })
