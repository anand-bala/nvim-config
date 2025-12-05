-- LSP Setup
vim.lsp.config("*", {
  root_markers = { ".jj", ".git" },
})

vim.lsp.enable {
  "bashls",
  "neocmake",
  "biome",
  "clangd",
  "emmet_language_server",
  "cssls",
  "jsonls",
  "jqls",
  "lua_ls",
  "lemminx",

  -- {{{ python
  "basedpyright",
  -- "jedi_language_server",
  -- "pylsp",
  -- "ty",
  -- "zuban",
  "ruff",
  -- }}}

  "ruby_lsp",
  "taplo",
  "texlab",
  "vimls",
  "vtsls",
  "yamlls",
  -- "digestif",
  "zotero_ls",
  "zls",
}

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Disable lsp formatexpr for Python, markdown, and tex",
  pattern = { "*.py", "*.md", "*.qmd", "*.tex" },
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end
    -- Use builtin formatexpr
    vim.opt_local.formatexpr = nil
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end
    if vim.tbl_contains({ "ruff", "ty" }, client.name) then
      -- Disable hover support from ruff and ty
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "LSP: Disable hover capability from ruff and ty",
})
