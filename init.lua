local should_profile = os.getenv "NVIM_PROFILE"
if should_profile then
  vim.pack.add { "https://github.com/stevearc/profile.nvim" }
  require("profile").instrument_autocmds()
  if should_profile:lower():match "^start" then
    require("profile").start "*"
  else
    require("profile").instrument "*"
  end
end

local function toggle_profile()
  local prof = require "profile"
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start "*"
  end
end
vim.keymap.set("", "<f1>", toggle_profile)

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
do
  local data = vim.fn.stdpath "state"
  assert(type(data) == "string")

  local project_root = vim.trim(require("_utils").get_vcs_root() or vim.fn.getcwd())
  local project_b64 = vim.base64.encode(vim.fn.fnamemodify(project_root, ":p"))
  local file = vim.fs.joinpath(data, "shada", project_b64 .. ".shada")
  vim.fn.mkdir(vim.fs.dirname(file), "p")
  vim.opt.shadafile = file
end

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

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append { W = true, I = true, c = true }
if vim.fn.has "nvim-0.9.0" == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append { C = true }
end

-- Better cmdline menu options
vim.opt.wildmode = {
  "full",
}
vim.opt.wildoptions = {
  "pum",
  "fuzzy",
}

-- vim.opt.completeopt to have a better completion experience
vim.opt.completeopt = {
  "menuone",
  "popup",
  "noinsert",
  "noselect",
  "fuzzy",
}

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

-- Show border for neovim windows
vim.opt.winborder = "rounded"

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

-- Center text after page up and down
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })
vim.keymap.set("n", "<PageUp>", "<PageUp>zz", { desc = "Page up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<PageDown>", "<PageDown>zz", { desc = "Page down" })

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
  vim.diagnostic.setloclist { severity = severity }
end, {
  desc = "Adds LSP diagnostic to the Location list",
  complete = function() return { "ERROR", "WARN", "HINT", "INFO" } end,
  nargs = "?",
})

vim.api.nvim_create_user_command("WorkspaceDiagnostics", function(args)
  vim.lsp.buf.workspace_diagnostics()
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

-- vim.g.loaded_tool_plugins = false
vim.g.loaded_fzf_plugin = false
-- vim.g.loaded_snacks_plugin = false
-- vim.g.loaded_ui_plugins = false
-- vim.g.loaded_securemodelines = false
-- vim.g.loaded_scratch = false
-- vim.g.loaded_tool_plugins = false
-- vim.g.loaded_term_helper = false

-- Disable modelines for .jjdescription files
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.jjdescription",
  callback = function(event) vim.bo[event.buf].modeline = false end,
})

vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "*",
  callback = function(args)
    assert(args.event == "PackChanged")

    ---@type {kind: "install"|"update"|"delete", spec: vim.pack.Spec, path: string}
    local event_data = args.data

    local kind = event_data.kind
    local pkg = event_data.spec
    local path = event_data.path

    if kind == "update" and vim.tbl_get(pkg, "data", "build") ~= nil then
      ---@type vim.api.keyset.echo_opts
      local progress = {
        kind = "progress",
        status = "running",
        title = "[package building] " .. pkg.name,
      }
      progress.id = vim.api.nvim_echo({ { "packadd-ing" } }, true, progress)
      vim.cmd(":packadd " .. pkg.name)

      vim.api.nvim_echo({ { "building" } }, true, progress)
      local t = type(pkg.data.build)
      if t == "function" then
        ---@diagnostic disable-next-line: param-type-mismatch
        local ok = pcall(pkg.data.build)
        progress.err = not ok
        progress.status = ok and "success" or "failed"
        local msg = ok and "success" or "failed"
        vim.api.nvim_echo({ { msg } }, true, progress)
      elseif t == "string" and pkg.data.build:sub(1, 1) == ":" then
        ---@diagnostic disable-next-line: param-type-mismatch
        local ok = pcall(vim.cmd, pkg.data.build)
        progress.err = not ok
        progress.status = ok and "success" or "failed"
        local msg = ok and "success" or "failed"
        vim.api.nvim_echo({ { msg } }, true, progress)
      elseif t == "string" then
        local command_args = {}
        for word in pkg.data.build:gmatch "%S+" do
          table.insert(command_args, word)
        end
        vim.system(
          command_args,
          { cwd = path },
          vim.schedule_wrap(function(obj)
            local ok = obj.code == 0
            progress.err = not ok
            progress.status = ok and "success" or "failed"
            local msg = ok and "success" or "failed"
            vim.api.nvim_echo({ { msg } }, true, progress)
          end)
        )
      end
    end
  end,
  desc = "vim.pack post-install/post-update hooks",
})

vim.pack.add {
  -- Everyday tools
  "https://github.com/tpope/vim-commentary",
  "https://github.com/tpope/vim-obsession",
  "https://github.com/tpope/vim-abolish",
  "https://github.com/arthurxavierx/vim-caser", -- Another casing plugin. Supports visual mode and text objects
  "https://github.com/tpope/vim-surround",
  "https://github.com/direnv/direnv.vim",
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/andymass/vim-matchup",
  "https://github.com/junegunn/vim-easy-align",
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/rafikdraoui/jj-diffconflicts",
  "https://github.com/whiteinge/diffconflicts",
  "https://github.com/tpope/vim-dispatch",
  "https://github.com/willothy/flatten.nvim",

  -- Fuzzy finders
  -- { src = "https://github.com/junegunn/fzf", data = { build = "./install --bin" } },
  -- { src = "https://github.com/ibhagwan/fzf-lua", version = "main" },
  "https://github.com/folke/snacks.nvim",

  -- UI stuff
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/lewis6991/hover.nvim",

  -- Coding tools
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", data = { build = ":TSUpdate" } },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },

  "https://github.com/nvim-mini/mini.completion",
  "https://github.com/nvim-mini/mini.snippets",
  "https://github.com/rafamadriz/friendly-snippets",

  -- Language specific stuff
  "https://github.com/mrcjkb/rustaceanvim",
  "https://github.com/lervag/vimtex",
  "https://github.com/preservim/vim-markdown",
  "https://github.com/lark-parser/vim-lark-syntax",
  "https://github.com/avm99963/vim-jjdescription",
  "https://github.com/HiPhish/jinja.vim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/b0o/schemastore.nvim",

  -- Helpers
  "https://github.com/mason-org/mason.nvim",

  -- Profiling tools
  "https://github.com/dstein64/vim-startuptime",

  -- Common Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-mini/mini.icons",

  "https://github.com/kkharji/sqlite.lua",
}
