---@diagnostic disable: missing-fields

if vim.g.loaded_tool_plugins ~= nil then return end
vim.g.loaded_tool_plugins = 1

local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

require("oil").setup()
-- require("mini.align").setup()
do
  local hover = require "hover"
  hover.setup {
    init = function()
      -- Require providers
      require "hover.providers.lsp"
      require "hover.providers.fold_preview"
      require "hover.providers.diagnostic"
      require "hover.providers.man"
      -- require "hover.providers.dictionary"
    end,
  }
  vim.keymap.set("n", "K", function()
    local hover_win = vim.b.hover_preview
    if hover_win and vim.api.nvim_win_is_valid(hover_win) then
      vim.api.nvim_set_current_win(hover_win)
    else
      ---@diagnostic disable-next-line: missing-parameter
      hover.hover()
    end
  end, { desc = "hover.nvim" })
  vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })
  ---@diagnostic disable-next-line: missing-parameter
  vim.keymap.set("n", "<C-p>", function() hover.hover_switch "previous" end, { desc = "hover.nvim (previous source)" })
  ---@diagnostic disable-next-line: missing-parameter
  vim.keymap.set("n", "<C-n>", function() hover.hover_switch "next" end, { desc = "hover.nvim (next source)" })
end
-- autocmd({ "BufWritePost" }, {
--   group = augroup("Linting", { clear = true }),
--   callback = function() require("lint").try_lint() end,
-- })

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
    "vimdoc",
  },
  highlight = { enable = true, disable = { "latex" } },
  indent = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
  matchup = { enable = true },
}
require("treesitter-context").setup {
  max_lines = 4, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
}
do
  -- Adjust latex -> tex
  local latex_patterns = { "latex/**/*.json", "**/latex.json", "tex/**/*.json", "**/tex.json" }
  local lang_patterns = { tex = latex_patterns, plaintex = latex_patterns }
  local snippets = require "mini.snippets"
  snippets.setup {
    snippets = { snippets.gen_loader.from_lang { lang_patterns = lang_patterns } },
    mappings = { expand = "", jump_next = "", jump_prev = "" },
    expand = {
      match = function(snips)
        -- Do not match with whitespace to cursor's left
        return snippets.default_match(snips, { pattern_fuzzy = "%S+" })
      end,
    },
  }
  if _G.MiniSnippets ~= nil then _G.MiniSnippets.start_lsp_server { match = false } end
end

do
  require("mini.completion").setup {
    set_vim_settings = false,
    mappings = {
      --- disable force completion... just use <C-x><C-u>
      force_twostep = "",
      force_fallback = "",
    },
  }
  if _G.MiniCompletion ~= nil then vim.lsp.config("*", { capabilities = _G.MiniCompletion.get_lsp_capabilities() }) end
end

do
  local keycode = vim.keycode or function(x) return vim.api.nvim_replace_termcodes(x, true, true, true) end
  local keys = {
    ["cr"] = keycode "<CR>",
    ["ctrl-y"] = keycode "<C-y>",
    ["ctrl-y_cr"] = keycode "<C-y><CR>",
  }

  -- Use CR for selecting completion items
  local cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      -- If popup is visible, confirm selected item or add new line otherwise
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and keys["ctrl-y"] or keys["ctrl-y_cr"]
    else
      -- If popup is not visible, use plain `<CR>`.
      return keys["cr"]
    end
  end
  vim.keymap.set("i", "<CR>", cr_action, { expr = true })

  local jump_next = function()
    local is_active = MiniSnippets.session.get() ~= nil
    if is_active then
      MiniSnippets.session.jump "next"
      return ""
    end
    return "\t"
  end
  local jump_prev = function() MiniSnippets.session.jump "prev" end
  vim.keymap.set("i", "<Tab>", jump_next, { desc = "Jump forward if snippet tabstop is available", expr = true })
  vim.keymap.set("i", "<S-Tab>", jump_prev, { desc = "Jump backward if snippet tabstop is available" })
end

require("mason").setup()

-- Formatting
vim.g.formatting_opts = vim.g.formatting_opts or {}
vim.g.enable_autoformat = vim.g.enable_autoformat or true

require("conform").setup {
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome" },
    typescript = { "biome" },
    -- python = { "isort", "black" },
    yaml = { "yamlfmt" },
    bash = { "shfmt", "shellharden" },
    sh = { "shfmt", "shellharden" },
    cmake = { "gersemi" },
    tex = { "latexindent", lsp_format = "never" },
    bib = { "bibtex-tidy", lsp_format = "never" },
    markdown = { "injected", "mdformat" },
    matlab = { timeout_ms = 5000 },
  },
  formatters = {
    yamlfmt = { prepend_args = { "-formatter", "indent=2,retain_line_breaks=true" } },
    shfmt = { prepend_args = { "-i", "2" } },
    latexindent = { prepend_args = { "-l", "-m" } },
    biome = { append_args = { "--indent-style=space" } },
    ["bibtex-tidy"] = {
      prepend_args = {
        "--omit=abstract,keywords",
        "--numeric",
        "--months",
        "--no-align",
        "--sort=-year,key",
        "--duplicates=key,doi",
        "--merge=combine",
        "--strip-enclosing-braces",
        "--no-escape",
        "--sort-fields",
        "--strip-comments",
        "--trailing-commas",
        "--encode-urls",
        "--no-remove-dupe-fields",
        "--enclosing-braces=title,journal,series,booktitle",
        "--remove-braces=title,journal,series,booktitle",
      },
    },
  },
  format_on_save = function(bufnr)
    -- Disable with a global or buffer-local variable
    if vim.b[bufnr].enable_autoformat or (vim.b[bufnr].enable_autoformat == nil and vim.g.enable_autoformat) then
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

vim.api.nvim_create_user_command("FormatDisable", function(args) set_autoformat(false, args.bang) end, {
  desc = "Disable autoformat-on-save (use ! for buffer only)",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function(args) set_autoformat(true, args.bang) end, {
  desc = "Re-enable autoformat-on-save (use ! for buffer only)",
  bang = true,
})

-- Smaller configs
vim.g.matchup_matchparen_offscreen = { method = "popup" }
vim.g.matchup_override_vimtex = 1
vim.g.matchup_surround_enabled = 1
vim.g.abolish_save_file = vim.fs.joinpath(vim.fn.stdpath "config" --[[@as string]], "/after/plugin/abolish.vim")

vim.g.prosession_dir = vim.fs.joinpath(vim.fn.stdpath "data" --[[@as string]], "/sessions/")
vim.g.procession_ignore_dirs = { "~" }
vim.g.prosession_on_startup = 0

vim.g.startuptime_event_width = 0

require("flatten").setup()

--- Zeal command
vim.api.nvim_create_user_command("Zeal", function(args)
  if vim.fn.executable "zeal" == 0 then
    vim.notify("No executable named `zeal` on in PATH", vim.diagnostic.severity.ERROR)
  end
  local cmd = { "zeal" }
  assert(type(args.args) == "string")
  if args.args ~= "" then table.insert(cmd, args.args) end
  vim.system(cmd)
end, {
  desc = "Run Zeal for offline documentation",
  nargs = "?",
})
