---@type vim.lsp.Config
return {
  cmd = { "digestif" },
  filetypes = { "tex", "plaintex", "context" },
  root_markers = {
    "main.tex",
    "root.tex",
    ".latexmkrc",
    "latexindent.yaml",
    ".jj",
    ".git",
  },
}
