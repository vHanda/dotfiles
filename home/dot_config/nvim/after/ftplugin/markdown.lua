
-- Disable completion for Markdown buffers
require("cmp").setup.buffer {
  enabled = false,
}

-- Hard-wrap text at 80 characters while typing
vim.opt_local.textwidth = 80
vim.opt_local.formatoptions:append("t")
vim.opt_local.formatoptions:append("n")
