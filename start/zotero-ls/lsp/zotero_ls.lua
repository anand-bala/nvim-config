local zotero_ls = require "zotero_ls"

return {
  cmd = zotero_ls.make_lsp_cmd {
    zotero_db_path = "~/Zotero/zotero.sqlite",
    better_bibtex_db_path = "~/Zotero/better-bibtex.sqlite",
  },
  filetypes = { "quarto" },
  root_markers = {
    "_quarto.yml",
  },
}
