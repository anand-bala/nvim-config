local function clone_paq()
  local path = vim.fn.stdpath "data" .. "/site/pack/paqs/start/paq-nvim"
  local is_installed = vim.fn.empty(vim.fn.glob(path)) == 0
  if not is_installed then
    vim.fn.system {
      "git",
      "clone",
      "--depth=1",
      "https://github.com/savq/paq-nvim.git",
      path,
    }
    return true
  end
end

local function bootstrap_paq(packages)
  local first_install = clone_paq()
  vim.cmd.packadd "paq-nvim"
  local paq = require "paq"
  if first_install then
    vim.notify "Installing plugins... If prompted, hit Enter to continue."
  end

  -- Read and install packages
  paq(packages)
end

-- Call helper function
bootstrap_paq {
  "savq/paq-nvim",

  -- Utilities
  { "dstein64/vim-startuptime", opt = true },
  "nvim-lua/plenary.nvim",

  -- Everyday tools
  { "tpope/vim-obsession" },
  { "tpope/vim-abolish" },
  { "tpope/vim-fugitive" },
  { "andymass/vim-matchup" },
  { "junegunn/vim-easy-align" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "tpope/vim-commentary" },
  { "folke/which-key.nvim" },

  -- Direnv
  { "direnv/direnv.vim" },

  -- UI Stuff
  { "nvim-tree/nvim-web-devicons" },
  { "EdenEast/nightfox.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "stevearc/dressing.nvim" },
  { "nvim-lualine/lualine.nvim" },
  -- { "echasnovski/mini.statusline" },
  -- { "echasnovski/mini.tabline" },
  { "ls-devs/nvim-notify", branch = "fix/fix_index_value" },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },

  -- LSP and tools stuff
  { "neovim/nvim-lspconfig" },
  { "folke/neodev.nvim" },
  { "onsails/lspkind-nvim" },
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },

  -- Coding helpers
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-nvim-lua" },
  { "hrsh7th/cmp-omni" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },

  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
  -- { "mhartington/formatter.nvim" },
  -- { "mfussenegger/nvim-lint" },
  { "mrcjkb/rustaceanvim" },
  { "vigoux/ltex-ls.nvim" },
  { "nvimtools/none-ls.nvim" },

  { "preservim/vim-markdown" },
  { "lervag/vimtex" },

  -- { "3rd/image.nvim", opt = true },
  { "benlubas/molten-nvim", build = ":UpdateRemotePlugins", opt = true },
}
