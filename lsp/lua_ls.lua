---@type vim.lsp.Config
return {
  -- Note this is ignored if the project has a .luarc.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_init = function()
    local has_lazydev, lazydev = pcall(require, "lazydev")
    if has_lazydev then
      ---@diagnostic disable-next-line: missing-fields
      lazydev.setup {
        runtime = vim.env.VIMRUNTIME --[[@as string]],
        library = {
          -- Only load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
        integrations = {
          lspconfig = false,
          cmp = false,
          coq = false,
        },
      }
    end
  end,
}
