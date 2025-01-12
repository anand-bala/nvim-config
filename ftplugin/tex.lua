vim.opt_local.spell = true
vim.opt_local.spellfile = "project.utf-8.add"

vim.opt_local.textwidth = 80
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil

vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_mappings_enabled = 1
vim.g.vimtex_complete_enabled = 1
local complete_bib = vim.g.vimtex_complete_bib or {}
complete_bib.menu_fmt = ""
complete_bib.info_fmt = [[@author_short (@year), "@title"]]
vim.g.vimtex_complete_bib = complete_bib
vim.g.vimtex_compiler_enabled = 1
vim.g.vimtex_compiler_silent = 0
-- vim.g.vimtex_compiler_latexmk = {
--   continuous = 1,
-- }
vim.g.vimtex_compiler_method = function(mainfile)
  if vim.fn.filereadable(mainfile) == 1 then
    local lines = vim.fn.readfile(mainfile, "", 5)
    for _, line in ipairs(lines) do
      if string.match(line, "^.*arara") then
        return "arara"
      end
    end
  end

  return "latexmk"
end
vim.g.vimtex_view_enabled = 1
vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_forward_search_on_start = 0
vim.g.vimtex_view_automatic = 0
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_toc_config = {
  split_pos = "botright",
  fold_enable = 1,
}
vim.g.vimtex_toc_show_preamble = 0

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = { "*.tex" },
--   desc = "Use vimtex to compile document on save",
--   callback = function(ctx)
--     -- vim.cmd [[echo b:vimtex.compiler]]
--     local compiler_is_running =
--       vim.api.nvim_call_dict_function("b:vimtex.compiler", "is_running", {})
--     if compiler_is_running then
--       -- vim.notify(
--       --   string.format("Compiler already running for buf %s", ctx.file),
--       --   vim.log.levels.INFO
--       -- )
--       return
--     end
--     vim.cmd [[:VimtexCompileSS]]
--   end,
-- })

local vimtex_compile_user_augroup =
  vim.api.nvim_create_augroup("CustomVimtexCompile", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompileSuccess",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for successful vimtex compilation",
  callback = function()
    vim.notify("Compilation completed", vim.log.levels.INFO, { title = "VimTeX" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompileFailed",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for failed vimtex compilation",
  callback = function()
    vim.notify("Compilation failed!", vim.log.levels.WARN, { title = "VimTeX" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventCompiling",
  group = vimtex_compile_user_augroup,
  desc = "Custom callback for when vimtex starts compilation",
  callback = function()
    vim.notify("Compilation started", vim.log.levels.INFO, { title = "VimTeX" })
  end,
})
