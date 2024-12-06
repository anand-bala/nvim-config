vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.textwidth = 127

if vim.fn.exists ":VTerm" then
  vim.cmd [[command! -buffer -nargs=0 Repl VTerm ipython]]
end

vim.schedule(function()
  -- Install pyright when we first open
  require("_utils").mason_install "pyright"
end)
