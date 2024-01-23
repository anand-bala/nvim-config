local luasnip = require "luasnip"
luasnip.filetype_extend("cpp", { "c" })
luasnip.filetype_extend("tex", { "latex" })
luasnip.filetype_set("latex", { "latex", "tex" })
luasnip.filetype_extend("markdown", { "latex", "tex" })
luasnip.filetype_extend("pandoc", { "markdown", "latex", "tex" })
luasnip.filetype_extend("quarto", { "markdown", "latex", "tex" })

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()
