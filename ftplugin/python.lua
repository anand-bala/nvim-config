vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.textwidth = 88

if vim.fn.exists ":VTerm" then vim.cmd [[command! -buffer -nargs=0 Repl VTerm ipython]] end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    -- Use builtin formatexpr
    vim.opt_local.formatexpr = nil
  end,
})
