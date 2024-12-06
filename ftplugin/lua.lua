vim.schedule(function()
  require("_utils").mason_install {
    "stylua",
    "lua-language-server",
  }
  vim.cmd [[:packadd lazydev.nvim]]
  require("lazydev").setup()
end)
