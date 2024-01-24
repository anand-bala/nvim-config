require("quarto").setup {
  lspFeatures = {
    enabled = true,
    languages = { "r", "python", "julia" },
    chunks = "curly", -- 'curly' or 'all'
    diagnostics = {
      enabled = true,
      triggers = { "BufWrite" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = false,
    default_method = "molten", -- 'molten' or 'slime'
    ft_runners = {
      python = "molten",
    },
  },
}
