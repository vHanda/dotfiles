vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

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

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- Enable save / copy / paste in neovide
if vim.g.neovide then
  local is_macos = vim.uv.os_uname().sysname == "Darwin"

  local save_key  = is_macos and "<D-s>" or "<C-S-s>"
  local copy_key  = is_macos and "<D-c>" or "<C-S-c>"
  local paste_key = is_macos and "<D-v>" or "<C-S-v>"

  local function save() vim.cmd.write() end
  local function copy() vim.cmd([[normal! "+y]]) end
  local function paste() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end

  vim.keymap.set({ "n", "i", "v" }, save_key, save, { desc = "Save" })
  vim.keymap.set("v", copy_key, copy, { silent = true, desc = "Copy" })
  vim.keymap.set({ "n", "i", "v", "c", "t" }, paste_key, paste, { silent = true, desc = "Paste" })
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
