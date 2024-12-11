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
require("treesitter-context").setup {
  max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
}

-- require("blink.compat").setup {
--   debug = true,
-- }
require("blink.cmp").setup {
  keymap = {
    preset = "enter",
    ["<C-j>"] = { "snippet_forward" },
    -- ["<CR>"] = { "accept", "fallback" },
  },
  sources = {
    -- add lazydev to your completion providers
    per_filetype = {
      lua = { "lazydev", "lsp", "snippets", "path", "buffer" },
      -- tex = { "vimtex", "lsp", "snippets", "path", "buffer" },
    },
    default = { "lsp", "snippets", "path", "buffer" },
    providers = {
      lsp = {
        min_keyword_length = 0,
      },
      snippets = {
        extended_filetypes = {
          cpp = { "c" },
          markdown = { "tex" },
          pandoc = { "markdown", "tex" },
          quarto = { "markdown", "tex" },
        },
        score_offset = -5,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- dont show LuaLS require statements when lazydev has items
        fallbacks = { "lsp" },
      },
      vimtex = {
        name = "vimtex",
        module = "integrations.blink.vimtex",
        -- module = "blink.compat.source",
        fallbacks = { "lsp" },
        override = {
          get_trigger_characters = function()
            return { "{", "[", "\\" }
          end,
        },
        transform_items = function(ctx, items)
          for i, _ in ipairs(items) do
            items[i].kind = items[i].kind or vim.lsp.protocol.CompletionItemKind.Text
          end
          return items
        end,
      },
    },
  },
  fuzzy = { use_typo_resistance = false },
  -- menu = { draw = { align_to_component = "none" } },
  list = { selection = "manual" },
  signature = { enabled = true },
  -- completion = { accept = { auto_brackets = { enabled = true } } },
  completion = {
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },
      },
    },
    -- documentation = { auto_show = true },
    signature = { enabled = true },
  },
}

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "status" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fn.stdpath "config" .. "/after/plugin/abolish.vim"

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0
