do
  local path_package = vim.fn.stdpath "data" .. "/site/"
  local mini_path = path_package .. "pack/deps/start/mini.deps"
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd 'echo "Installing `mini.deps`" | redraw'
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.deps",
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd "packadd mini.deps | helptags ALL"
    vim.cmd 'echo "Installed `mini.deps`" | redraw'
  end
  require("mini.deps").setup { path = { package = path_package } }
end

local add = MiniDeps.add

-- Utilities
add "dstein64/vim-startuptime"
add "nvim-lua/plenary.nvim"

-- Everyday tools
add "tpope/vim-abolish"
add "tpope/vim-commentary"
add "tpope/vim-obsession"
--add("NeogitOrg/neogit")
add "sindrets/diffview.nvim"

add "andymass/vim-matchup"
add {
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function()
      vim.cmd ":TSUpdate"
    end,
  },
}
--add("dhruvasagar/vim-prosession")
add "direnv/direnv.vim"

-- UI Stuff
add "nvim-tree/nvim-web-devicons"
add "EdenEast/nightfox.nvim"
add "lewis6991/gitsigns.nvim"
add "stevearc/dressing.nvim"
add "nvim-lualine/lualine.nvim"
add "rcarriga/nvim-notify"

-- Fuzzy finder
add {
  source = "nvim-telescope/telescope.nvim",
  checkout = "0.1.x",
  monitor = "0.1.x",
  depends = {
    { source = "jmbuhr/telescope-zotero.nvim", depends = { "kkharji/sqlite.lua" } },
  },
}

-- LSP and tools stuff
add "neovim/nvim-lspconfig"
add "folke/neodev.nvim"
add "onsails/lspkind-nvim"
add "williamboman/mason.nvim"
add "williamboman/mason-lspconfig.nvim"

-- Coding helpers
add {
  source = "hrsh7th/nvim-cmp",
  depends = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-omni",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
  },
}

add {
  source = "L3MON4D3/LuaSnip",
  depends = { "rafamadriz/friendly-snippets" },
  hooks = {
    ---@class MiniDepsHookParams
    ---@field path string Absolute path to plugin's directory
    ---@field source string resolved <source> from spc
    ---@field name string resolved <name> from spec

    ---@param opts MiniDepsHookParams
    post_install = function(opts)
      vim.notify(
        string.format("Running make install_jsregexp for LuaSnip (%s)", opts.path)
      )
      vim.system({ "make", "install_jsregexp" }, {
        cwd = opts.path,
        text = true,
        detach = true,
      }, function(obj)
        if obj.code ~= 0 then
          local lines = {
            "Unable to install LuaSnip with jsregexp",
            "",
            "Exit Code: " .. obj.code .. " (" .. obj.signal .. ")",
            "```",
            obj.stderr,
            "```",
          }
          vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR, {
            title = "LuaSnip installation",
            on_open = function(win)
              vim.api.nvim_set_option_value("conceallevel", 3, {
                win = win,
              })
              vim.api.nvim_set_option_value("spell", false, {
                win = win,
              })
              local buf = vim.api.nvim_win_get_buf(win)
              vim.treesitter.start(buf, "markdown")
            end,
          })
        else
          vim.notify "Successfully built LuaSnip with jsregexp"
        end
      end)
    end,
  },
}
add "mrcjkb/rustaceanvim"
add "vigoux/ltex-ls.nvim"
add "nvimtools/none-ls.nvim"
add "preservim/vim-markdown"
add "lervag/vimtex"

-- add {
--   source = "benlubas/molten-nvim",
--   hooks = {
--     post_checkout = function()
--       vim.cmd ":UpdateRemotePlugins"
--     end,
--   },
--   depends = {
--     "3rd/image.nvim",
--   },
-- }
