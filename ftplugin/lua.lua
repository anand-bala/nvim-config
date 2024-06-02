MiniDeps.add "folke/lazydev.nvim"
MiniDeps.later(function()
  require("lazydev").setup {}
end)
