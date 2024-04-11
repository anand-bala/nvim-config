if vim.g.loaded_lsp_plugins then
  return
end
vim.g.loaded_lsp_plugins = true

local mason_opts = {
  ensure_installed = {
    "stylua",
    "lua-language-server",
    "shellcheck",
    "shfmt",
    "shellharden",
  },
}

local function configure_lsp()
  local _ = require "lspconfig"
  -- try to load mason first
  do
    local mason = require "mason"
    mason.setup(mason_opts)
    local mr = require "mason-registry"
    mr.refresh(function()
      for _, tool in ipairs(mason_opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end

  require("neodev").setup {
    experimental = { pathStrict = true },
    plugins = { "nvim-dap-ui" },
    types = true,
  }

  local opts = require "config.lsp.servers" or {}

  -- setup autoformat
  require("config.lsp.format").setup(opts)
  -- Setup diagnostics
  require("config.lsp").diagnostics(opts)
  local servers = opts.servers
  local setup = opts.setup_lsp_config

  for server, server_opts in pairs(servers) do
    if server_opts then
      setup(server)
    end
  end

  require("mason-lspconfig").setup_handlers { setup }

  do
    local null_ls = require "null-ls"
    local sources = {
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.formatting.taplo,
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.yamlfmt.with {
        extra_args = {
          "-formatter",
          "-indent=2,retain_line_breaks=true",
        },
      },
      null_ls.builtins.formatting.shfmt.with {
        extra_args = { "-i", "2" },
      },
      -- null_ls.builtins.formatting.latexindent.with {
      --   extra_args = { "-m", "-l" },
      -- },
      null_ls.builtins.diagnostics.mypy,
      -- null_ls.builtins.diagnostics.shellcheck,
      null_ls.builtins.formatting.shellharden,
      null_ls.builtins.diagnostics.cmake_lint,
    }

    null_ls.setup {
      sources = sources,
      debug = true,
      on_attach = require("config.lsp.format").on_attach,
    }
  end
end

configure_lsp()

-- LSP default on_attach hooks
require("config.lsp").on_attach_hook(
  require("config.lsp").keymaps,
  { desc = "LSP: setup default keymaps", group = "LspDefaultKeymaps" }
)
require("config.lsp").on_attach_hook(
  require("config.lsp.format").on_attach,
  { desc = "LSP: setup formatting", group = "LspAttachFormatting" }
)
