local lsp_installer = require "nvim-lsp-installer"
local myconfigs = require "_lsp/configs"

local function ensure_installed()
  local ensure_installed_servers = { "vimls", "sumneko_lua" }
  for _, name in ipairs(ensure_installed_servers) do
    local ok, server = lsp_installer.get_server(name)
    -- Check that the server is supported in nvim-lsp-installer
    if ok and not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end

local function setup_custom_handlers()
  -- [[ Formatting handler ]]
  vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
      return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
      local view = vim.fn.winsaveview()
      vim.lsp.util.apply_text_edits(result, bufnr)
      vim.fn.winrestview(view)
      if bufnr == vim.api.nvim_get_current_buf() then
        vim.api.nvim_command "noautocmd :update"
      end
    end
  end
end

local function on_attach(client, bufnr)
  local utils = require "_utils"
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  if
    client.resolved_capabilities.document_formatting
    or client.resolved_capabilities.document_range_formatting
  then
    utils.create_buffer_augroup("lspformat", {
      [[BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 1000)]], -- Run all formatters at 1000ms timeout
    })
  end
  require("_keymaps/lsp").setup(client, bufnr)

  -- utils.create_buffer_augroup(
  --   "lspbehavior",
  --   { [[CursorHold  <buffer>  lua vim.lsp.diagnostic.show_line_diagnostics()]] }
  -- )
end

ensure_installed()
setup_custom_handlers()

local capabilities = require("cmp_nvim_lsp").update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local default_conf = {
  on_init = function(client)
    client.config.flags = {}
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
  end,
  on_attach = on_attach,
  capabilities = capabilities,
}

lsp_installer.on_server_ready(function(server)
  local opts = vim.tbl_extend("force", default_conf, myconfigs[server.name])

  server:setup(opts)

  vim.cmd [[ do User LspAttachBuffers ]]
end)
