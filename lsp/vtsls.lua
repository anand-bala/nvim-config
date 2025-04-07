---@type vim.lsp.ClientConfig
return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".jj", ".git" },
  settings = {
    typescript = {
      format = {
        enable = false,
      },
    },
    javascript = {
      format = {
        enable = false,
      },
    },
  },
}
