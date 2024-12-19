vim.schedule(function()
  require("_utils").mason_install {
    "stylua",
    "lua-language-server",
  }
end)
