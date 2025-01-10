return vim.tbl_deep_extend(
  "force",
  require("lspconfig.configs.basics_ls").default_config,
  {
    settings = {
      buffer = {
        enable = true,
        minCompletionLength = 4, -- only provide completions for words longer than 4 characters
        matchStrategy = "exact", -- or 'fuzzy'
      },
      path = {
        enable = true,
      },
      snippet = {
        enable = false,
        sources = vim.api.nvim_get_runtime_file("snippets/", true),
        matchStrategy = "exact", -- or 'fuzzy'
      },
    },
  }
)
