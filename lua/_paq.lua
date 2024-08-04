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
  { "nvim-telescope/telescope.nvim", branch = "0.1.x", opt = true },

  -- UI stuff
  "echasnovski/mini.notify",
  "EdenEast/nightfox.nvim",
  { "lewis6991/gitsigns.nvim" },
  { "stevearc/dressing.nvim" },
  { "nvim-lualine/lualine.nvim" },

  -- Coding tools
  "neovim/nvim-lspconfig",
  "stevearc/conform.nvim",
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "mfussenegger/nvim-lsp-compl",

  -- Language specific stuff
  { "mrcjkb/rustaceanvim" },
  { "vigoux/ltex-ls.nvim", opt = true },
  { "lervag/vimtex" },
  { "preservim/vim-markdown" },
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

local pkgs_count = #require("paq").query "to_install"
if pkgs_count >= 1 then
  vim.notify(string.format("There are %d to install", pkgs_count))
  paq.install()
  vim.cmd [[helptags ALL]]
end
