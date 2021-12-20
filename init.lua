-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  -- "matchit",
  -- "matchparen",
  "shada_plugin",
  "tarPlugin",
  "tar",
  "netrwPlugin",
}

for _, disabled_plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. disabled_plugin] = 1
end

-- Fishshell fixes
if string.match(vim.o.shell, "fish$") then
  vim.g.terminal_shell = "fish"
  vim.opt.shell = "sh"
end

vim.cmd "syntax enable"

require "_plugins"

---[[ Sanity settings
vim.opt.secure = true
vim.opt.modelines = 0 -- Disable Modelines
vim.opt.number = true -- Show line numbers
vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
vim.opt.encoding = "utf-8" -- Encoding

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 120

vim.opt.formatoptions = "tcqrnj"

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = false

vim.opt.conceallevel = 2

vim.opt.foldenable = true
vim.opt.foldminlines = 2
vim.opt.foldnestmax = 3
vim.opt.foldlevel = 0
vim.opt.foldlevelstart = 0
vim.opt.fillchars = { fold = " ", foldopen = "", foldclose = "" }
vim.opt.foldcolumn = "auto:3"
vim.opt.foldtext =
  [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
vim.opt.foldopen = "all"
vim.opt.foldclose = "all"

vim.opt.list = true -- Show non-printable characters.
vim.opt.listchars = {
  tab = "▸ ",
  extends = "❯",
  precedes = "❮",
  nbsp = "±",
  trail = "·",
}

vim.opt.breakindent = true
vim.opt.breakindentopt = "sbr"
vim.opt.showbreak = " "

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Spelling
vim.opt.spelllang = "en_us"
vim.opt.spell = false

-- Interface Settings
-- vim.opt.background=dark
vim.opt.mouse = "a"
vim.opt.showmode = false

-- vim.opt.completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append({ c = true }, { I = true })

-- Split pane settings
-- Right and bottom splits as opposed to left and top
vim.opt.splitbelow = true
vim.opt.splitright = true

--Enable break indent
vim.opt.breakindent = true

--Save undo history
vim.opt.undofile = true

--Decrease update time
-- vim.opt.updatetime = 250
vim.wo.signcolumn = "yes"
---]]

---[[ GUI options

vim.cmd [[let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"]]
vim.opt.termguicolors = true
vim.g.dracula_colorterm = 1
vim.cmd [[colorscheme dracula]]
---]]

require "_keymaps"
require "_ide"

--- Register some custom behavior via autocmds
local augroup = require("_utils").create_augroup

-- Spell check on for the following
augroup("spellceck_ft_specific", {
  [[FileType markdown   setlocal spell]],
  [[FileType gitcommit  setlocal spell]],
  [[FileType tex,latex  setlocal spell]],
})

-- Make textwidth smaller for these filetypes
augroup("textwidth_ft_specific", {
  [[FileType markdown   setlocal textwidth=88]],
  [[FileType gitcommit  setlocal textwidth=79]],
  [[FileType tex,latex  setlocal textwidth=88]],
})

-- Custom filetype mappings
augroup("ft_mappings", { [[BufRead,BufNewFile *.tex,*.latex  set filetype=tex]] })

-- Update folds on startup
augroup("update_folds", {
  [[BufEnter * :normal zx]],
})

-- Make the cursor vertically centered
augroup("vertical_center_cursor", {
  [[BufEnter,WinEnter,WinNew,VimResized *,*.* let &scrolloff=winheight(win_getid())/2]],
})

-- Terminal
augroup("terminal_settings", { [[TermOpen * setlocal nonumber norelativenumber]] })
