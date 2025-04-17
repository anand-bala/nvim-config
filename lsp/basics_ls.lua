---@type vim.lsp.Config
return {
  cmd = { "bunx", "basics-language-server" },
  root_markers = {
    ".jj",
    ".git",
  },
  settings = {
    buffer = {
      enable = false,
    },
    path = {
      enable = true,
    },
    snippet = {
      enable = false,
      sources = vim.api.nvim_get_runtime_file("snippets/", true),
      matchStrategy = "fuzzy",
    },
  },
}
