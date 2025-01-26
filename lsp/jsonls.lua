---@type vim.lsp.ClientConfig
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {},
  },
  on_init = function(client)
    local snippet_conf = vim.deepcopy(require("schemastore").json.get "VSCode Code Snippets" or {})
    assert(snippet_conf ~= nil and snippet_conf.fileMatch ~= nil)
    -- Update snippet conf to include all json files matching **/snippets/**/*.json
    table.insert(snippet_conf.fileMatch, 1, "**/snippets/*.json")

    client.settings.json = vim.tbl_deep_extend("force", client.settings.json --[[@as table]] or {}, {
      schemas = require("schemastore").json.schemas {
        replace = {
          ["VSCode Code Snippets"] = snippet_conf,
        },
      },
      validate = { enable = true },
    })
  end,
}
