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
  -- try to load neoconf and mason first
  require("neoconf").setup {
    import = {
      vscode = false, -- local .vscode/settings.json
      coc = false, -- global/local coc-settings.json
      nlsp = false, -- global/local nlsp-settings.nvim json settings
    },
  }

  require("mason").setup(mason_opts)
  local mr = require "mason-registry"
  mr.refresh(function()
    for _, tool in ipairs(mason_opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end)

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
  local capabilities = require("config.lsp").update_capabilities(opts)

  local servers = opts.servers or {}

  local function setup(server)
    local server_opts = servers[server] or {}

    server_opts["capabilities"] =
      vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup["*"] then
      if opts.setup["*"](server, server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  for server, server_opts in pairs(servers) do
    if server_opts then
      setup(server)
    end
  end
  --
  -- require("mason-lspconfig").setup { ensure_installed = opts.mason or {} }
  require("mason-lspconfig").setup_handlers { setup }

  local null_ls = require "null-ls"

  local sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.taplo,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.yamlfmt.with {
      extra_args = {
        "-formatter",
        "-indent=2,retain_line_breaks=true",
      },
    },
    null_ls.builtins.formatting.shfmt,
    null_ls.builtins.formatting.latexindent.with {
      extra_args = { "-m", "-l" },
    },
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.shellcheck,
    null_ls.builtins.diagnostics.cmake_lint,
  }

  null_ls.setup {
    sources = sources,
  }
end

configure_lsp()

-- LSP default on_attach hooks
require("config.lsp").on_attach_hook(
  require("config.lsp").keymaps,
  { desc = "LSP: setup default keymaps", group = "LspDefaultKeymaps" }
)
