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

-- read :h vim.lsp.config for changing options of lsp servers 
