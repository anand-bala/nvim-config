---@type vim.lsp.Config
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  settings = {
    -- ty = { disableLanguageServices = false },
    ty = {
      diagnosticMode = "workspace",
      experimental = {
        rename = true,
      },
    },
  },
  init_options = {
    logFile = vim.fs.joinpath(vim.fn.stdpath "log", "lsp", "ty.log"),
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
