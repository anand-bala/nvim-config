---@type vim.lsp.ClientConfig
return {
  cmd = { "bunx", "vim-language-server", "--stdio" },
  filetypes = { "vim" },
  root_markers = {
    "runtime",
    "autoload",
    "plugin",
    ".jj",
    ".git",
  },
  init_options = {
    isNeovim = true,
    iskeyword = "@,48-57,_,192-255,-#",
    vimruntime = "",
    runtimepath = "",
    diagnostic = { enable = true },
    indexes = {
      runtimepath = true,
      gap = 100,
      count = 3,
      projectRootPatterns = { "runtime", "nvim", ".git", ".jj", "autoload", "plugin" },
    },
    suggest = { fromVimruntime = true, fromRuntimepath = true },
  },
  settings = {},
}
