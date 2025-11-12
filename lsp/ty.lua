---@type vim.lsp.Config
return {
  settings = {
    -- ty = { disableLanguageServices = false },
    ty = {
      diagnosticMode = "workspace",
      experimental = {
        rename = true,
      },
    },
  },
  init_options = {
    logFile = vim.fs.joinpath(vim.fn.stdpath "log", "lsp", "ty.log"),
  },
}
