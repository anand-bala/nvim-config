do
  local path_package = vim.fs.joinpath(vim.fn.stdpath "data" --[[@as string]], "site")
  local paq_path = vim.fs.joinpath(path_package, "pack/deps/start/paq-nvim")
  if not vim.uv.fs_stat(paq_path) then
    vim.cmd 'echo "Installing `paq-nvim`" | redraw'
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/savq/paq-nvim",
      paq_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd "packadd paq-nvim"
    vim.cmd 'echo "Installed `paq`" | redraw'
  end
end

local paq = require "paq"

paq {
  -- Everyday tools
  "tpope/vim-commentary",
  "tpope/vim-obsession",
  "tpope/vim-abolish",
  "arthurxavierx/vim-caser", -- Another casing plugin. Supports visual mode and text objects
  "direnv/direnv.vim",
  "stevearc/oil.nvim",
  "andymass/vim-matchup",
  "echasnovski/mini.align",
  "echasnovski/mini.ai",
  "rafikdraoui/jj-diffconflicts",
  "stevearc/overseer.nvim",

  -- Fuzzy finders
  { "junegunn/fzf", build = "./install --bin" },
  { "ibhagwan/fzf-lua", branch = "main" },

  -- UI stuff
  "rcarriga/nvim-notify",
  "EdenEast/nightfox.nvim",
  "lewis6991/gitsigns.nvim",
  "stevearc/dressing.nvim",
  "nvim-lualine/lualine.nvim",
  "kevinhwang91/nvim-bqf",
  "stevearc/quicker.nvim",
  "lewis6991/hover.nvim",

  -- Coding tools
  -- "neovim/nvim-lspconfig",
  "stevearc/conform.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  "nvim-treesitter/nvim-treesitter-context",

  "saghen/blink.compat",
  { "saghen/blink.cmp", build = "cargo build --release" },
  "rafamadriz/friendly-snippets",

  -- Language specific stuff
  "mrcjkb/rustaceanvim",
  "lervag/vimtex",
  "preservim/vim-markdown",
  "lark-parser/vim-lark-syntax",
  "avm99963/vim-jjdescription",
  "folke/lazydev.nvim",
  "b0o/schemastore.nvim",
  "OXY2DEV/helpview.nvim",

  -- Helpers
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Nice to haves
  { "dstein64/vim-startuptime", opt = true },

  -- Common Dependencies
  "nvim-lua/plenary.nvim",
  "echasnovski/mini.icons",
}

---@type Package[]
local to_install = require("paq").query "to_install"
local pkgs_count = #to_install
if pkgs_count >= 1 then
  vim.notify(string.format("There are %d to install", pkgs_count))
  paq.install()
  vim.cmd [[helptags ALL]]

  -- Disable plugins and ask user to restart
  vim.opt.loadplugins = false
  vim.notify(
    "New plugins installed, you may want to restart your session after paq completes installing things",
    vim.log.levels.WARN
  )
end
