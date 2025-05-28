---@module "rustaceanvim"

vim.opt.textwidth = 88

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event) vim.lsp.inlay_hint.enable(false, { bufnr = event.buf }) end,
  desc = "disable LSP inlay hints for Rust. Use rustaceanvim.",
})
