if vim.g.loaded_lsp_plugins then
  return
end
vim.g.loaded_lsp_plugins = true

local add = MiniDeps.add
local later = MiniDeps.later

add "williamboman/mason.nvim"
add "williamboman/mason-lspconfig.nvim"
later(function()
  local mason_opts = {
    ensure_installed = {
      "stylua",
      "lua-language-server",
      "shellcheck",
      "shfmt",
      "shellharden",
    },
  }
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

  local setup = require("config.lsp.servers").setup_lsp_config
  require("mason-lspconfig").setup_handlers { setup }
end)

add "folke/neodev.nvim"
later(function()
  require("neodev").setup {
    experimental = { pathStrict = true },
    plugins = { "nvim-dap-ui" },
    types = true,
  }
end)

add "neovim/nvim-lspconfig"
later(function()
  local opts = require "config.lsp.servers" or {}

  local servers = opts.servers
  local setup = opts.setup_lsp_config

  for server, server_opts in pairs(servers) do
    if server_opts then
      setup(server)
    end
  end
end)

-- LSP default on_attach hooks
require("config.lsp").on_attach_hook(
  require("config.lsp").keymaps,
  { desc = "LSP: setup default keymaps", group = "LspDefaultKeymaps" }
)
