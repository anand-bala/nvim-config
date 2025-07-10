vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.textwidth = 88

--- remove line wrapping
vim.opt_local.formatoptions = vim.opt_local.formatoptions - "t" - "c"
--- add #: to comments
vim.opt_local.comments:prepend "b:#:"

if vim.fn.exists ":VTerm" then vim.cmd [[command! -buffer -nargs=0 Repl VTerm ipython]] end
