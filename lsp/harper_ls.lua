---@type vim.lsp.ClientConfig
return {
  cmd = { "harper-ls", "--stdio" },
  filetypes = {
    "c",
    "cmake",
    "cpp",
    "cs",
    "dart",
    "gitcommit",
    "go",
    "haskell",
    "html",
    "java",
    "javascript",
    "lua",
    "markdown",
    "nix",
    "php",
    "plaintex",
    "python",
    "ruby",
    "rust",
    "swift",
    "tex",
    "toml",
    "typescript",
    "typescriptreact",
    "typst",
  },
  settings = {
    ["harper-ls"] = {
      linters = {
        SentenceCapitalization = false,
        SpellCheck = false,
      },
    },
  },
}
