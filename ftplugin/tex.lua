local vimtex_compile_user_augroup = vim.api.nvim_create_augroup("CustomVimtexCompile", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompileSuccess",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for successful vimtex compilation",
  callback = function() vim.notify("Compilation completed", vim.log.levels.INFO, { title = "VimTeX" }) end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompileFailed",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for failed vimtex compilation",
  callback = function() vim.notify("Compilation failed!", vim.log.levels.WARN, { title = "VimTeX" }) end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompiling",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for when vimtex starts compilation",
  callback = function() vim.notify("Compilation started", vim.log.levels.INFO, { title = "VimTeX" }) end,
})
