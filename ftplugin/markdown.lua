vim.opt_local.spell = true
vim.opt_local.spellfile = "project.utf-8.add"

vim.opt_local.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt_local.softtabstop = 2 -- Size of a soft tab
vim.opt_local.shiftwidth = 2 -- Size of indent

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil

vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_autowrite = 1
vim.g.vim_markdown_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_edit_url_in = "vsplit"
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_follow_anchor = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_new_list_item_indent = 0
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_toc_autofit = 1
vim.g.vim_markdown_toml_frontmatter = 1

vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "R=r" }
