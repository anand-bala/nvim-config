require("oil").setup()
-- require("mini.align").setup()
require("mini.ai").setup()

---@diagnostic disable-next-line missing-fields
require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "html",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "vim",
  },
  highlight = { enable = true, disable = { "latex" } },
  indent = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  matchup = { enable = true },
}

local luasnip = require "luasnip"

luasnip.filetype_extend("cpp", { "c" })
luasnip.filetype_extend("tex", { "latex" })
luasnip.filetype_set("latex", { "latex", "tex" })
luasnip.filetype_extend("markdown", { "latex", "tex" })
luasnip.filetype_extend("pandoc", { "markdown", "latex", "tex" })
luasnip.filetype_extend("quarto", { "markdown", "latex", "tex" })

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

local has_compl, compl = pcall(require, "lsp_compl")
if has_compl then
  -- compl.expand_snippet = luasnip.lsp_expand
  require("config.lsp").on_attach_hook(compl.attach)
  vim.keymap.set("i", "<CR>", function()
    return compl.accept_pum() and "<c-y>" or "<CR>"
  end, { expr = true })
  vim.keymap.set("i", "<C-p>", function()
    compl.trigger_completion()
  end)
  vim.keymap.set("i", "<C-n>", function()
    compl.trigger_completion()
  end)
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    -- Backward
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end)
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    -- Forward
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    end
  end)
end

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = {
  "~",
}
vim.g.prosession_on_startup = 0
