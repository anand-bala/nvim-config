local opts = {}

-- try to load neoconf first
do
  local constants = require "rocks-config.constants"
  local api = require "rocks.api"
  local user_configuration = api.get_rocks_toml()
  local config =
    vim.tbl_deep_extend("force", constants.DEFAULT_CONFIG, user_configuration or {})
  local plugins_dir = config.config.plugins_dir:gsub("[%.%/%\\]+$", "")

  local search = table.concat({ config.config.plugins_dir, "neoconf" }, ".")
  local ok, err = pcall(require, search)
  if
    not ok
    and type(err) == "string"
    and not err:match("module%s+." .. search:gsub("%p", "%%%1") .. ".%s+not%s+found")
  then
    error(err)
  end
end

-- merge options
opts = vim.tbl_deep_extend("force", opts, require "config.lsp.servers" or {}) or {}

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
