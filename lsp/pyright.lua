local pyright = vim.fn.executable "basedpyright" == 1 and "basedpyright" or "pyright"
---@type vim.lsp.Config
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
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = "openFilesOnly",
      inlayHints = {
        callArgumentNames = true,
      },
      analysis = {
        useTypingExtensions = true,
      },
    },
  },
}
