local pyright = vim.fn.executable "basedpyright" == 1 and "basedpyright" or "pyright"
return {
  cmd = { pyright .. "-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".jj",
    ".git",
  },
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
    basedpyright = {
      analysis = {
        typeCheckingMode = "strict",
      },
    },
  },
}
