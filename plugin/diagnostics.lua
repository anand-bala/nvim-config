if vim.g.loaded_diagnostics_plugins then
  return
end
vim.g.loaded_diagnostics_plugins = true

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
