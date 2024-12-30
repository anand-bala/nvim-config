---@diagnostic disable: missing-fields

if vim.g.loaded_tool_plugins ~= nil then
  return
end
vim.g.loaded_tool_plugins = 1

require("oil").setup()
-- require("mini.align").setup()
require("mini.ai").setup()

vim.schedule(function()
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
end)

-- require("blink.compat").setup {
--   debug = true,
-- }
require("blink.cmp").setup {
  keymap = {
    preset = "enter",
    ["<C-j>"] = { "snippet_forward" },
    ["<C-p>"] = { "show", "select_prev", "fallback" },
    ["<C-n>"] = { "show", "select_next", "fallback" },
  },
  sources = {
    per_filetype = {
      tex = { "vimtex", "lsp", "snippets", "path", "buffer" },
    },
    default = { "lsp", "snippets", "path", "buffer" },
    providers = {
      lsp = {
        min_keyword_length = 0,
      },
      snippets = {
        opts = {
          extended_filetypes = {
            cpp = { "c" },
            markdown = { "tex" },
            pandoc = { "markdown", "tex" },
          },
        },
        -- score_offset = -5,
      },
      vimtex = {
        name = "vimtex",
        module = "blink.compat.source",
        override = {
          get_trigger_characters = function()
            return { "{", ",", "[", "\\" }
          end,
        },
      },
    },
    cmdline = {},
  },
  fuzzy = { use_typo_resistance = false },
  signature = { enabled = true },
  -- completion = { accept = { auto_brackets = { enabled = true } } },
  completion = {
    list = { selection = "manual" },
    menu = {
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },
      },
    },
    -- documentation = { auto_show = true },
  },
}

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fn.stdpath "config" .. "/after/plugin/abolish.vim"

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0
