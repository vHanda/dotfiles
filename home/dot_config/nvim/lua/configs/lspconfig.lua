require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
vim.lsp.enable(servers)

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--query-driver=**",
  },
})

vim.lsp.enable("clangd")

vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true;
      }
    }
  }
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('beancount', {
  commands = { "beancount-language-server", "--stdio" },
  root_markers = { "main.bean", ".git" },
  init_options = {
      journal_file = "main.bean",
  },
})
vim.lsp.enable('beancount')
-- FIXME: We need to manually run :TSIntall beancount
--        Figure out how that can be made to happen automatically

-- Run :help lspconfig-all for a full list of LSPs
-- read :h vim.lsp.config for changing options of lsp servers 
-- Run :checkhealth vim.lsp to debug
-- Check .local/state/nvim/lsp.log to debug
-- You can also add `:lua vim.lsp.set_log_level("debug")`
-- :=vim.lsp.log_levels -> :lua print(vim.inspect(vim.lsp.log_levels)))
-- Check filetype via: set filetype?
