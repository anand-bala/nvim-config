---@type vim.lsp.ClientConfig
return {
  cmd = { "zotero_ls", "server" },
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
  init_options = {
    zotero_dir = vim.fs.joinpath(vim.uv.os_homedir(), "Zotero"),
  },
}
