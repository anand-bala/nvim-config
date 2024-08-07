if vim.g.loaded_formatting_plugins then
  return
end
vim.g.loaded_formatting_plugins = true

local add = MiniDeps.add
local later = MiniDeps.later

add "stevearc/conform.nvim"
later(function()
  local conform = require "conform"
  conform.formatters.yamlfmt = {
    prepend_args = {
      "-formatter",
      "-indent=2,retain_line_breaks=true",
    },
  }
  conform.formatters.shfmt = {
    prepend_args = { "-i", "2" },
  }

  conform.formatters.latexindent = {
    prepend_args = { "-l", "-m" },
  }

  local default_format_opts = {
    timeout_ms = 1000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
  }

  vim.g.formatting_opts =
    vim.tbl_deep_extend("keep", vim.g.formatting_opts or {}, default_format_opts)

  local default_conform_opts = {
    timeout_ms = 1000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_fallback = true,
  }

  vim.g.enable_autoformat = vim.g.enable_autoformat or true

  conform.setup {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Use a sub-list to run only the first available formatter
      javascript = { { "prettierd", "prettier" } },
      yaml = { "yamlfmt" },
      bash = { "shfmt", "shellharden" },
      cmake = { "gersemi" },
      tex = { "latexindent" },
      markdown = { "mdformat" },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.b[bufnr].enable_autoformat or vim.g.enable_autoformat then
        local opts =
          vim.tbl_deep_extend("keep", vim.g.formatting_opts or {}, default_conform_opts)
        return opts
      end
    end,
  }

  ---@param set boolean
  ---@param buf_only boolean
  local function set_autoformat(set, buf_only)
    if buf_only then
      -- enable formatting just for this buffer
      vim.b.enable_autoformat = set
    else
      vim.g.enable_autoformat = set
    end
  end

  vim.api.nvim_create_user_command("FormatDisable", function(args)
    set_autoformat(false, args.bang)
  end, {
    desc = "Disable autoformat-on-save",
    bang = true,
  })
  vim.api.nvim_create_user_command("FormatEnable", function(args)
    set_autoformat(true, args.bang)
  end, {
    desc = "Re-enable autoformat-on-save",
    bang = true,
  })

  vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
      local end_line =
        vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
      range = {
        start = { args.line1, 0 },
        ["end"] = { args.line2, end_line:len() },
      }
    end
    local opts =
      vim.tbl_deep_extend("keep", vim.g.formatting_opts or {}, default_conform_opts, {
        range = range,
      })
    require("conform").format(opts)
  end, { range = true })

  vim.keymap.set("n", "<leader>f", function()
    local opts =
      vim.tbl_deep_extend("keep", vim.g.formatting_opts or {}, default_conform_opts)
    require("conform").format(opts)
  end, {
    desc = "Format the document",
  })
end)
