do
  local path_package = vim.fn.stdpath "data" .. "/site/"
  local paq_path = path_package .. "pack/deps/start/paq-nvim"
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
  --"dhruvasagar/vim-prosession",
  "direnv/direnv.vim",
  "stevearc/oil.nvim",
  "andymass/vim-matchup",
  -- "echasnovski/mini.align",
  "junegunn/vim-easy-align",
  "echasnovski/mini.ai",
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", opt = true },

  -- UI stuff
  -- "echasnovski/mini.notify",
  "rcarriga/nvim-notify",
  "EdenEast/nightfox.nvim",
  "lewis6991/gitsigns.nvim",
  "stevearc/dressing.nvim",
  "nvim-lualine/lualine.nvim",

  -- Coding tools
  "neovim/nvim-lspconfig",
  "stevearc/conform.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",

  -- "mfussenegger/nvim-lsp-compl",

  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-omni",
  "hrsh7th/cmp-path",
  "saadparwaiz1/cmp_luasnip",
  "micangl/cmp-vimtex",
  "onsails/lspkind-nvim",

  -- Language specific stuff
  "mrcjkb/rustaceanvim",
  "lervag/vimtex",
  "preservim/vim-markdown",
  "lark-parser/vim-lark-syntax",
  "avm99963/vim-jjdescription",
  { "vigoux/ltex-ls.nvim", opt = true },
  { "folke/lazydev.nvim", opt = true },

  -- Helpers
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- Nice to haves
  { "dstein64/vim-startuptime", opt = true },

  -- Common Dependencies
  "nvim-lua/plenary.nvim",
  "nvim-tree/nvim-web-devicons",
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
