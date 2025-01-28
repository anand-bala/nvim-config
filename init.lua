-- Enable the experimental lua loader
vim.loader.enable()
-- Set some sane defaults
vim.opt.secure = true
vim.opt.modelines = 0 -- Disable Modelines
vim.opt.number = true -- Show line numbers
vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.undofile = true -- Save undo history
-- vim.opt.clipboard = "unnamedplus" -- Sync OS and Neovim clipboard

-- Create per-project shada files
vim.opt.shadafile = (function()
  local data = vim.fn.stdpath "state"
  assert(type(data) == "string")

  local project_root = vim.trim(require("_utils").get_vcs_root() or vim.fn.getcwd())
  local project_b64 = vim.base64.encode(vim.fn.fnamemodify(project_root, ":p"))
  local file = vim.fs.joinpath(data, "shada", project_b64 .. ".shada")
  vim.fn.mkdir(vim.fs.dirname(file), "p")
  return file
end)()

-- Fixes for fish shell
if string.match(vim.o.shell, "fish$") then
  vim.g.terminal_shell = "fish"
  vim.opt.shell = "sh"
end

-- Enable vim syntax highlighting
-- vim.cmd "syntax enable"

-- Default formatting options
vim.opt.encoding = "utf-8" -- Default encoding
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 88

vim.opt.formatoptions = "tcqrn21j"

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt.softtabstop = 2 -- Size of a soft tab
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.breakindent = true -- Indent visually wrapped lines

-- Sane searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Preview substitutions live
vim.opt.inccommand = "split"

-- Default spelling settings
vim.opt.spelllang = "en_us"
vim.opt.spell = false

-- Conceal text completely and substiture with custom character
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

-- Use smarter complete options
-- vim.opt.completeopt to have a better completion experience
vim.opt.completeopt = {
  "menuone",
  "popup",
  "noinsert",
  "noselect",
  "fuzzy",
}

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append { W = true, I = true, c = true }
if vim.fn.has "nvim-0.9.0" == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append { C = true }
end

-- GUI options
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Don't show mode since we are using statusline

-- Turn on global statusline
vim.opt.laststatus = 3
-- Turn on sign column
vim.wo.signcolumn = "yes"

-- Default to light background
vim.opt.background = "light"

-- Split pane settings
-- Right and bottom splits as opposed to left and top
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sane timeout limits
vim.opt.timeout = true
vim.opt.timeoutlen = 300 -- decreate mapped sequence wait time
vim.opt.updatetime = 250 -- decrease update time

-- Show non-printable characters.
vim.opt.list = true
vim.opt.listchars = {
  tab = "▸ ",
  extends = "❯",
  precedes = "❮",
  nbsp = "±",
  trail = "·",
  lead = "▸",
  leadmultispace = "·",
}

-- Setup terminal colors correctly
vim.cmd [[let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"]]
vim.opt.termguicolors = true

-- Set the leader character.
-- Personally, I like backslash
vim.g.mapleader = "\\"

-- Setup sane keymaps

-- Disable 'hjkl' for movements
-- vim.keymap.set("", "h", "<nop>", { remap = false })
-- vim.keymap.set("", "j", "<nop>", { remap = false })
-- vim.keymap.set("", "k", "<nop>", { remap = false })
-- vim.keymap.set("", "l", "<nop>", { remap = false })

-- shifting visual block should keep it selected
vim.keymap.set("v", "<", "<gv", { remap = false })
vim.keymap.set("v", ">", ">gv", { remap = false })

-- go up/down on visual line
vim.keymap.set({ "n", "v" }, "<Down>", "gj", { remap = false, desc = "Move down on visual line" })
vim.keymap.set({ "n", "v" }, "<Up>", "gk", { remap = false, desc = "Move up on visual line" })
vim.keymap.set("i", "<Down>", "<C-o>gj", { remap = false, desc = "Move down on visual line" })
vim.keymap.set("i", "<Up>", "<C-o>gk", { remap = false, desc = "Move up on visual line" })

-- Yank entire line on Y
vim.keymap.set("n", "Y", "yy", { remap = false })

-- Navigate buffers
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { remap = false, desc = "Move to next buffer in list" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { remap = false, desc = "Move to previous buffer in list" })

--- Diagnostics
vim.lsp.inlay_hint.enable(true)
local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = " ",
  [vim.diagnostic.severity.INFO] = " ",
}
vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    spacing = 4,
    source = true,
    prefix = function(diagnostic) return diagnostic_icons[diagnostic.severity] end,
  },
  signs = {
    text = diagnostic_icons,
  },
  float = {
    source = true,
  },
  severity_sort = true,
}

vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump { float = true, count = -1 } end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump { float = true, count = 1 } end)
vim.keymap.set(
  "n",
  "[D",
  function()
    vim.diagnostic.jump {
      float = true,
      count = -1,
      severity = vim.diagnostic.severity.ERROR,
    }
  end
)
vim.keymap.set(
  "n",
  "]D",
  function()
    vim.diagnostic.jump {
      float = true,
      count = 1,
      severity = vim.diagnostic.severity.ERROR,
    }
  end
)

vim.api.nvim_create_user_command("Diagnostics", function(args)
  local severity = vim.diagnostic.severity[args.args] or nil
  vim.diagnostic.setqflist { severity = severity }
end, {
  desc = "Adds LSP diagnostic to the Quickfix list",
  complete = function() return { "ERROR", "WARN", "HINT", "INFO" } end,
  nargs = "?",
})

-- Disable some providers I generally don't use
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Load/install plugins
require "_paq"

-- LSP Setup
vim.lsp.config("*", {
  root_markers = { ".jj", ".git" },
})

vim.lsp.enable {
  "bashls",
  "clangd",
  "jsonls",
  "lua_ls",
  "pyright",
  "ruff",
  "taplo",
  "texlab",
  "yamlls",
}

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set({ "n", "v" }, "<leader><Space>", vim.lsp.buf.code_action, { desc = "Code actions", buffer = bufnr })
    vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })

    if vim.opt.loadplugins then
      local has_fzf_lua, fzf_lua = pcall(require, "fzf-lua")
      if has_fzf_lua then
        vim.keymap.set("n", "<C-]>", fzf_lua.lsp_definitions, { desc = "Go to definitions", buffer = bufnr })
        vim.keymap.set("n", "gr", fzf_lua.lsp_references, { desc = "[G]o to [R]eferences", buffer = bufnr })
        vim.keymap.set("n", "gd", fzf_lua.lsp_references, { desc = "[G]o to References (compat)", buffer = bufnr })
      end
    end
  end,
  desc = "LSP: setup default keymaps",
  group = vim.api.nvim_create_augroup("LspDefaultKeymaps", { clear = true }),
})
