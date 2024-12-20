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

local cmp = require "cmp"

--- Mappings for nvim-cmp
local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

local mapping = cmp.mapping {
  ["<CR>"] = cmp.mapping.confirm { select = false },
  ["<C-y>"] = cmp.mapping.confirm { select = true },
  ["<C-e>"] = cmp.mapping.abort(),
  ["<C-u>"] = cmp.mapping.scroll_docs(-4),
  ["<C-d>"] = cmp.mapping.scroll_docs(4),
  ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
  ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
  ["<C-p>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_prev_item(cmp_select_opts)
    else
      cmp.complete()
    end
  end),
  ["<C-n>"] = cmp.mapping(function()
    if cmp.visible() then
      cmp.select_next_item(cmp_select_opts)
    else
      cmp.complete()
    end
  end),
  ["<C-k>"] = cmp.mapping(function(fallback)
    -- Backward
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<C-j>"] = cmp.mapping(function(fallback)
    -- Forward
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

local opts = {
  mapping = mapping,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    -- fields = { "abbr", "kind", "menu" },
    format = require("lspkind").cmp_format {
      mode = "symbol_text", -- show only symbol annotations
      -- maxwidth = 50, -- prevent the popup from showing more than provided characters
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
    },
  },
  sources = cmp.config.sources {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer", keyword_length = 3 },
    { name = "treesitter" },
    { name = "luasnip", keyword_length = 2 },
  },
}

cmp.setup(opts)

-- Filetype specific sources

-- lua
cmp.setup.filetype("lua", {
  sources = cmp.config.sources {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" },
  },
})

-- tex
cmp.setup.filetype(
  "tex",
  cmp.config.sources {
    { name = "vimtex" },
    { name = "nvim_lsp" },
    { name = "omni" },
    { name = "luasnip" },
    { name = "path" },
  }
)

-- markdown
cmp.setup.filetype("markdown", {
  sources = {
    { name = "otter" }, -- Quarto completion source
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
    { name = "luasnip" },
  },
})

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "status" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fn.stdpath "config" .. "/after/plugin/abolish.vim"

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0
