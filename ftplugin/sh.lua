vim.schedule(function()
  require("_utils").mason_install {
    "shellcheck",
    "shfmt",
    "shellharden",
    "bash-language-server",
  }
end)
