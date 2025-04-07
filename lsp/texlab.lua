return {
  cmd = { "texlab" },
  filetypes = { "tex", "plaintex", "bib" },
  root_markers = {
    ".latexmkrc",
    "latexindent.yaml",
    ".texlabroot",
    "texlabroot",
    "Tectonic.toml",
    ".jj",
    ".git",
  },
  settings = {
    texlab = {
      rootDirectory = nil,
      build = {
        executable = "latexmk",
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
        onSave = false,
        forwardSearchAfter = false,
      },
      forwardSearch = {
        executable = nil,
        args = {},
      },
      chktex = {
        onOpenAndSave = false,
        onEdit = false,
      },
      diagnosticsDelay = 300,
      -- bibtexFormatter = "none",
      -- latexFormatter = "none",
      latexindent = {
        modifyLineBreaks = true,
      },
      inlayHints = {
        labelReferences = false,
      },
    },
  },
}
