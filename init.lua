-- Enable the experimental lua loader
vim.loader.enable()

-- Set some sane defaults
vim.opt.secure = true
vim.opt.modelines = 0 -- Disable Modelines
vim.opt.number = true -- Show line numbers
vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.undofile = true -- Save undo history
vim.opt.clipboard = "unnamedplus" -- Sync OS and Neovim clipboard

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
  "menu",
  "menuone",
  "preview",
  "noinsert",
  -- "noselect",
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
vim.keymap.set("n", "<Down>", "gj", { remap = false })
vim.keymap.set("n", "<Up>", "gk", { remap = false })
vim.keymap.set("v", "<Down>", "gj", { remap = false })
vim.keymap.set("v", "<Up>", "gk", { remap = false })
vim.keymap.set("i", "<Down>", "<C-o>gj", { remap = false })
vim.keymap.set("i", "<Up>", "<C-o>gk", { remap = false })

-- Yank entire line on Y
vim.keymap.set("n", "Y", "yy", { remap = false })

-- Navigate buffers
vim.keymap.set(
  "n",
  "]b",
  "<cmd>bnext<cr>",
  { remap = false, desc = "Move to next buffer in list" }
)
vim.keymap.set(
  "n",
  "[b",
  "<cmd>bprevious<cr>",
  { remap = false, desc = "Move to previous buffer in list" }
)

--- Diagnostics
vim.lsp.inlay_hint.enable(true)
vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    spacing = 4,
    source = true,
    prefix = function(diagnostic)
      local icons = require("config.icons").diagnostics
      return icons[diagnostic.severity]
    end,
  },
  signs = {
    text = require("config.icons").diagnostics,
  },
  float = {
    source = true,
  },
  severity_sort = true,
}

vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump { float = true, count = -1 }
end)
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump { float = true, count = 1 }
end)
vim.keymap.set("n", "[D", function()
  vim.diagnostic.jump {
    float = true,
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
  }
end)
vim.keymap.set("n", "]D", function()
  vim.diagnostic.jump {
    float = true,
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
  }
end)

-- Commands to set the quickfix buffer/loclist buffer
vim.api.nvim_create_user_command("Diagnostics", function()
  vim.diagnostic.setloclist { title = "Buffer Diagnostics" }
end, {
  desc = "Populate location list for this buffer with diagnostics",
  force = true,
})
vim.api.nvim_create_user_command("WorkspaceDiagnostics", function()
  vim.diagnostic.setqflist { title = "Workspace Diagnostics" }
end, {
  desc = "Populate quickfix list for with workspace diagnostics",
  force = true,
})

-- Populate quickfix list when diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist { title = "WorkspaceDiagnostics", open = false }
  end,
})

-- LSP debug
-- vim.lsp.set_log_level "DEBUG"
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist { title = "WorkspaceDiagnostics", open = false }
  end,
})

-- Disable some providers I generally don't use
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Load/install plugins
require "_mini_deps"
-- vim.cmd "colorscheme dayfox"

-- Register some custom behavior via autocmds

local autocmd = vim.api.nvim_create_autocmd

-- Terminal
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
})

---@class NvimUserCommmand
---@field name string
---@field args string?
---@field fargs string[]?
---@field nargs string
---@field bang boolean
---@field line1 number
---@field line2 number
---@field range number
---@field count number
---@field reg string?
---@field mods string?
