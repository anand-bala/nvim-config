vim.api.nvim_create_autocmd("PackChanged", {
  pattern = "*",
  callback = function(args)
    assert(args.event == "PackChanged")

    ---@type {kind: "install"|"update"|"delete", spec: vim.pack.Spec, path: string}
    local event_data = args.data

    local kind = event_data.kind
    local pkg = event_data.spec
    local path = event_data.path

    if kind == "update" and pkg.data.build ~= nil then
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
  { src = "https://github.com/junegunn/fzf", data = { build = "./install --bin" } },
  { src = "https://github.com/ibhagwan/fzf-lua", version = "main" },

  -- UI stuff
  "https://github.com/EdenEast/nightfox.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/stevearc/quicker.nvim",
  "https://github.com/lewis6991/hover.nvim",

  -- Coding tools
  "https://github.com/stevearc/conform.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main", data = { build = ":TSUpdate" } },
  "https://github.com/nvim-treesitter/nvim-treesitter-context",

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
  "https://github.com/stevearc/profile.nvim",
  "https://github.com/dstein64/vim-startuptime",

  -- Common Dependencies
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-mini/mini.icons",

  "https://github.com/kkharji/sqlite.lua",
}
