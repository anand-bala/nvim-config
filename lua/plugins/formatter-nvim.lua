---@class FormatterSpec
---@field exe string
---@field args? string[]
---@field stdin? boolean
---@field cwd? string
---@field no_append? boolean

local opts = {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,

  ---@type table<string, (fun(): FormatterSpec)[]>
  filetype = {
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    python = {
      require("formatter.filetypes.python").isort,
      function()
        local util = require "lspconfig.util"
        ---@type FormatterSpec
        local black = require("formatter.filetypes.python").black()
        local bufname = vim.api.nvim_buf_get_name(0)
        vim.list_extend(black.args, {
          "--stdin-filename",
          bufname,
        })
        black.cwd =
          util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", ".git/")(bufname)

        return black
      end,
    },
    toml = {
      require("formatter.filetypes.toml").taplo,
    },
    yaml = {
      function()
        local yamlfmt = require("formatter.filetypes.yaml").yamlfmt()
        vim.list_extend(yamlfmt.args, {
          "-formatter",
          "-indent=2,retain_line_breaks=true",
        })
        return yamlfmt
      end,
    },
    bash = {
      require("formatter.filetypes.sh").shfmt,
    },
    tex = {
      function()
        local latexindent = require("formatter.filetypes.latex").latexindent()
        vim.list_extend(latexindent.args, {
          "-m",
          "-l",
        })
        return latexindent
      end,
    },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      -- require("formatter.filetypes.any").remove_trailing_whitespace,
    },
  },
}

require("formatter").setup(opts)
