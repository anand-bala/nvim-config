vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.textwidth = 80
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil

vim.g.vimtex_mappings_enabled = 0
vim.g.vimtex_complete_enabled = 1
vim.g.vimtex_view_enabled = 0
vim.g.vimtex_format_enabled = 1
vim.g.vimtex_toc_config = {
  split_pos = "botright",
  fold_enable = 1,
}
vim.g.vimtex_toc_show_preamble = 0
vim.g.vimtex_syntax_conceal = {
  accents = 1,
  cites = 1,
  fancy = 1,
  greek = 1,
  math_bounds = 1,
  math_delimiters = 1,
  math_fracs = 1,
  math_super_sub = 1,
  math_symbols = 1,
  sections = 0,
  styles = 1,
}
