vim.opt_local.spell = true
vim.opt_local.spellfile = "project.utf-8.add"

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.textwidth = 80
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil

MiniDeps.add "lervag/vimtex"

vim.g.vimtex_mappings_enabled = 0
vim.g.vimtex_complete_enabled = 1
vim.g.vimtex_view_enabled = 0
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_toc_config = {
  split_pos = "botright",
  fold_enable = 1,
}
vim.g.vimtex_toc_show_preamble = 0
