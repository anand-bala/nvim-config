---@diagnostic disable: missing-fields

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

require("blink.cmp").setup {
  keymap = {
    preset = "enter",
    ["<C-j>"] = { "snippet_forward" },
    -- ["<CR>"] = { "accept", "fallback" },
  },
  sources = {
    -- add lazydev to your completion providers
    per_filetype = {
      lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
      tex = { "lsp", "path", "snippets", "buffer", "vimtex" },
    },
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
      lsp = {
        min_keyword_length = 1,
      },
      snippets = {
        extended_filetypes = {
          cpp = { "c" },
          markdown = { "tex" },
          pandoc = { "markdown", "tex" },
          quarto = { "markdown", "tex" },
        },
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- dont show LuaLS require statements when lazydev has items
        fallbacks = { "lsp" },
      },
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        fallbacks = { "lsp" },
      },
    },
  },
  fuzzy = { use_typo_resistance = false },
  -- menu = { draw = { align_to_component = "none" } },
  list = { selection = "manual" },
  -- completion = { accept = { auto_brackets = { enabled = true } } },
  signature = { enabled = true },
}

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "status" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fn.stdpath "config" .. "/after/plugin/abolish.vim"

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0
