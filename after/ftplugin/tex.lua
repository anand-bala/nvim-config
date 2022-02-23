vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.spellfile = "project.utf-8.add"
vim.opt_local.textwidth = 88

if vim.fn.exists ":TexlabForward" then
  vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
    silent = false,
    buffer = true,
    remap = false,
  })
end

if vim.fn.exists ":TexlabBuild" then
  vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
    silent = false,
    buffer = true,
    remap = false,
  })
end

local cmp = require "cmp"
cmp.setup.buffer {
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        omni = (vim.inspect(vim_item.menu):gsub('%"', "")),
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        treesitter = "[TS]",
        spell = "[Spell]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "omni" },
    { name = "luasnip" },
    { name = "buffer" },
    -- { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "spell" },
  },
}
