if vim.g.loaded_diagnostics_plugins then
  return
end
vim.g.loaded_diagnostics_plugins = true

vim.lsp.inlay_hint.enable(true)

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = vim.diagnostic.severity.ERROR,
    spacing = 4,
    source = true,
    prefix = function(diagnostic)
      local icons = require("config.icons").diagnostics
      return icons[diagnostic.severity]
    end,
  },
  signs = {
    text = require("config.icons").diagnostics,
  },
  float = {
    source = true,
  },
  severity_sort = true,
}

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
