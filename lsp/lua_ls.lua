return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },

  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".jj",
    ".git",
  },
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
}
