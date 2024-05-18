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

vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20

-- Load some opt packages deferred
local function md_notebook()
  local packadd = function(pkg)
    vim.cmd("packadd " .. pkg)
  end
  packadd "image.nvim"
  require("image").setup {
    backend = "kitty",
    tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
    max_width = 100, -- tweak to preference
    max_height = 12, -- ^
    max_height_window_percentage = math.huge, -- this is necessary for a good experience
    max_width_window_percentage = math.huge,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  }

  packadd "molten-nvim"

  -- Setup runner
  local runner = require "quarto.runner"
  vim.keymap.set(
    "n",
    "<localleader>rc",
    runner.run_cell,
    { desc = "run cell", silent = true }
  )
  vim.keymap.set(
    "n",
    "<localleader>ra",
    runner.run_above,
    { desc = "run cell and above", silent = true }
  )
  vim.keymap.set(
    "n",
    "<localleader>rA",
    runner.run_all,
    { desc = "run all cells", silent = true }
  )
  vim.keymap.set(
    "n",
    "<localleader>rl",
    runner.run_line,
    { desc = "run line", silent = true }
  )
  vim.keymap.set(
    "v",
    "<localleader>r",
    runner.run_range,
    { desc = "run visual range", silent = true }
  )
  vim.keymap.set("n", "<localleader>RA", function()
    runner.run_all(true)
  end, { desc = "run all cells of all languages", silent = true })
end

local command = vim.api.nvim_create_user_command
command("LoadMdNotebook", md_notebook, { force = true })

local add = MiniDeps.add
add "preservim/vim-markdown"
