---@type vim.lsp.Config
return {
  cmd = { "uvx", "jedi-language-server" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".jj",
    ".git",
  },
  init_options = {
    completion = { disableSnippets = true },
  },
}
