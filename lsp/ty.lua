---@type vim.lsp.Config
return {
  cmd = { "uvx", "ty", "server" },
  filetypes = { "python" },
  init_options = {
    settings = {
      python = { ty = { disableLanguageServices = true } },
      diagnosticMode = "workspace",
    },
  },
  root_markers = {
    "ty.toml",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".jj",
    ".git",
  },
}
