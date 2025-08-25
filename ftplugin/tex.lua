vim.opt_local.spell = true
vim.opt_local.spellfile = "project.utf-8.add"
vim.opt_local.textwidth = 77
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

--- Add treesitter highlighting
vim.treesitter.start(nil, "latex")
vim.bo.syntax = "ON" -- only if additional legacy syntax is needed

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
