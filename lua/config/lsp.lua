local map = vim.keymap.set

local M = {}

--- Wrapper to add `on_attach` hooks for LSP
---@param on_attach fun(client:vim.lsp.Client, buffer:integer)
---@param opts? {desc?:string,once?:boolean,group?:integer|string}
function M.on_attach_hook(on_attach, opts)
  opts = opts or {}
  if opts["group"] ~= nil and type(opts.group) == "string" then
    opts.group = vim.api.nvim_create_augroup(opts.group --[[@as string]], {})
  end
  vim.api.nvim_create_autocmd(
    "LspAttach",
    vim.tbl_extend("force", opts, {
      callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil then
          on_attach(client, buffer)
        end
      end,
    })
  )
end

function M.update_capabilities(opts)
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local has_compl, compl = pcall(require, "lsp_compl")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_compl and compl.capabilities() or {},
    opts.capabilities or {}
  )
  assert(capabilities ~= nil)
  -- https://github.com/neovim/neovim/issues/23291
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end

--- Mappings for built-in LSP client
--- @param _ vim.lsp.Client
--- @param bufnr integer
function M.keymaps(_, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param modes string|table|nil
  local lspmap = function(lhs, rhs, modes)
    modes = modes or { "n" }
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map(modes, lhs, rhs, lsp_map_opts)
  end
  local telescope = require "telescope.builtin"

  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-]>", function()
    telescope.lsp_references {
      show_line = false,
      fname_width = 50,
    }
  end)
  lspmap("gd", telescope.lsp_definitions)
  lspmap("<C-s>", require("telescope.builtin").lsp_document_symbols)
  lspmap("<leader><Space>", vim.lsp.buf.code_action, { "n", "v" })
  lspmap("<leader>rn", vim.lsp.buf.rename, { "n" })
end

function M.setup()
  local mason_opts = {
    ensure_installed = {},
  }
  local mason = require "mason"
  mason.setup(mason_opts)

  local setup = require("config.lsp.servers").setup_lsp_config
  local opts = require "config.lsp.servers" or {}
  local servers = opts.servers

  require("mason-lspconfig").setup_handlers { setup }
  for server, server_opts in pairs(servers) do
    if server_opts then
      setup(server)
    end
  end
end

return M
