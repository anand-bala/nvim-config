vim.opt_local.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt_local.softtabstop = 2 -- Size of a soft tab
vim.opt_local.shiftwidth = 2 -- Size of indent

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil

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
