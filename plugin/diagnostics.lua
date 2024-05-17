if vim.g.loaded_diagnostics_plugins then
  return
end
vim.g.loaded_diagnostics_plugins = true

for name, icon in pairs(require("config.icons").diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end

local opts = require("config.lsp").opts
local on_attach_hook = require("config.lsp").on_attach_hook

if opts.inlay_hints.enabled then
  on_attach_hook(function(client, buffer)
    if client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
    end
  end, { desc = "LSP: Enable inlay hints" })
end

if
  type(opts.diagnostics.virtual_text) == "table"
  and opts.diagnostics.virtual_text.prefix == "icons"
then
  opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
    or function(diagnostic)
      local icons = require("config.icons").diagnostics
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
    end
end

vim.diagnostic.config(opts.diagnostics)

-- Commands to set the quickfix buffer/loclist buffer
vim.api.nvim_create_user_command("Diagnostics", function()
  vim.diagnostic.setloclist { title = "Buffer Diagnostics" }
end, {
  desc = "Populate location list for this buffer with diagnostics",
  force = true,
})
vim.api.nvim_create_user_command("WorkspaceDiagnostics", function()
  vim.diagnostic.setqflist { title = "Workspace Diagnostics" }
end, {
  desc = "Populate quickfix list for with workspace diagnostics",
  force = true,
})

-- Populate quickfix list when diagnostics change
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist { title = "WorkspaceDiagnostics", open = false }
  end,
})

-- LSP debug
-- vim.lsp.set_log_level "DEBUG"
vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.diagnostic.setqflist { title = "WorkspaceDiagnostics", open = false }
  end,
})

-- LSP debug
-- vim.lsp.set_log_level "DEBUG"
