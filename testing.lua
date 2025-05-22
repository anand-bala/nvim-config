local ZoteroDb = require "zotero_ls.database"

local db = ZoteroDb:new {
  zotero_db_path = "~/Zotero/zotero.sqlite",
  better_bibtex_db_path = "~/Zotero/better-bibtex.sqlite",
}
assert(db ~= nil)

vim.print(vim.inspect(db:get_items()))
