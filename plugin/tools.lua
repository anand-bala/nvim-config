---@diagnostic disable: missing-fields

if vim.g.loaded_tool_plugins ~= nil then
  return
end
vim.g.loaded_tool_plugins = 1

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

require("oil").setup()
require("mini.align").setup()
require("hover").setup {
  init = function()
    -- Require providers
    require "hover.providers.lsp"
    -- require('hover.providers.gh')
    -- require('hover.providers.gh_user')
    -- require('hover.providers.jira')
    -- require('hover.providers.dap')
    require "hover.providers.fold_preview"
    require "hover.providers.diagnostic"
    require "hover.providers.man"
    -- require('hover.providers.dictionary')
  end,
}

autocmd({ "BufReadPost" }, {
  group = augroup("Lazy loaded tools", { clear = true }),
  once = true,
  pattern = "*",
  callback = function()
    require("mini.ai").setup()
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
  end,
})

vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
})
require("blink.cmp").setup {
  keymap = {
    preset = "enter",
    ["<C-j>"] = { "snippet_forward" },
    ["<C-p>"] = { "show", "select_prev", "fallback" },
    ["<C-n>"] = { "show", "select_next", "fallback" },
  },
  sources = {
    per_filetype = {
      tex = { "vimtex", "snippets", "path", "buffer" },
      lua = { "lazydev", "lsp", "path", "snippets", "buffer" },
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
        score_offset = -5,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- make lazydev completions top priority (see `:h blink.cmp`)
        score_offset = 100,
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
    list = {
      selection = "manual",
      -- selection = {
      --   preselect = false,
      --   auto_insert = false,
      -- },
    },
    accept = {
      auto_brackets = {
        override_brackets_for_filetypes = {
          tex = { "{", "}" },
        },
      },
    },
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

require("mason").setup()
require("mason-lspconfig").setup()

autocmd({ "FileType" }, {
  group = augroup("Auto-install tools", { clear = true }),
  pattern = "*",
  callback = function(ctx)
    local tools = require("_utils").get_configured_tools(ctx.buf)
    local to_install = {}
    for name, info in pairs(tools) do
      if not info.available then
        table.insert(to_install, name)
      end
    end
    require("_utils").mason_install(to_install)
  end,
})

-- Formatting
vim.g.formatting_opts = vim.g.formatting_opts or {}
vim.g.enable_autoformat = vim.g.enable_autoformat or true

require("conform").setup {
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black", "injected" },
    javascript = { "biome", stop_after_first = true },
    yaml = { "yamlfmt" },
    bash = { "shfmt", "shellharden" },
    cmake = { "gersemi" },
    tex = { "latexindent" },
    markdown = { "injected", "mdformat" },
    matlab = { timeout_ms = 5000 },
  },
  formatters = {
    yamlfmt = { prepend_args = { "-formatter", "indent=2,retain_line_breaks=true" } },
    shfmt = { prepend_args = { "-i", "2" } },
    latexindent = { prepend_args = { "-l", "-m" } },
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if
      vim.b[bufnr].enable_autoformat
      or (vim.b[bufnr].enable_autoformat == nil and vim.g.enable_autoformat)
    then
      return vim.g.formatting_opts or {}
    end
  end,
}

---@param set boolean
---@param buf_only boolean
local function set_autoformat(set, buf_only)
  if buf_only then
    -- enable formatting just for this buffer
    vim.b.enable_autoformat = set
  else
    vim.g.enable_autoformat = set
  end
end

vim.api.nvim_create_user_command("FormatDisable", function(args)
  set_autoformat(false, args.bang)
end, {
  desc = "Disable autoformat-on-save (use ! for buffer only)",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function(args)
  set_autoformat(true, args.bang)
end, {
  desc = "Re-enable autoformat-on-save (use ! for buffer only)",
  bang = true,
})

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fn.stdpath "config" .. "/after/plugin/abolish.vim"

vim.g.prosession_dir = vim.fn.stdpath "data" .. "/sessions/"
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0
