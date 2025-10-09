---@type vim.lsp.Config
return {
  cmd = { "neocmakelsp", "--stdio" },
  filetypes = { "cmake" },
  root_markers = { ".jj", ".git", "build", "cmake" },
}
