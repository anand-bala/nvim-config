local bib = require "zotero_ls.bib"
local ZoteroDb = require "zotero_ls.database"

local M = {}

local default_opts = {
  zotero_db_path = "~/Zotero/zotero.sqlite",
  better_bibtex_db_path = "~/Zotero/better-bibtex.sqlite",
  -- specify options for different filetypes
  -- locate_bib can be a string or a function
  ft = {
    quarto = {
      trigger_patterns = { "@" },
      locate_bib = bib.locate_quarto_bib,
    },
    tex = {
      trigger_patterns = { "{" },
      locate_bib = bib.locate_tex_bib,
    },
    plaintex = {
      trigger_patterns = { "{" },
      locate_bib = bib.locate_tex_bib,
    },
    -- fallback for unlisted filetypes
    default = {
      trigger_patterns = { "@" },
      locate_bib = bib.locate_quarto_bib,
    },
  },
}
M.config = default_opts

---@param opts {zotero_db_path: string, better_bibtex_db_path: string, max_authors: integer|nil}
---@return fun(dispatchers: vim.lsp.rpc.Dispatchers): vim.lsp.rpc.PublicClient
M.make_lsp_cmd = function(opts)
  vim.validate("opts", opts, "table")
  vim.validate("opts.zotero_db_path", opts.zotero_db_path, "string")
  vim.validate("opts.better_bibtex_db_path", opts.better_bibtex_db_path, "string")
  vim.validate("opts.max_authors", opts.max_authors, "number", true)

  ---@type lsp.InitializeResult
  local initializeResult = {
    capabilities = {
      completionProvider = { triggerCharacters = M.config.ft.default.trigger_patterns, resolveProvider = false },
    },
  }
  local max_authors = opts.max_authors

  ---@param entry ZoteroItem
  ---@return lsp.CompletionItem
  local function make_compl_item(entry)
    ---@type lsp.CompletionItem

    local title = "**" .. (entry.title or "NA") .. "**"
    local year = (entry.date or ""):match "(%d%d%d%d)" or entry.date

    local authors = vim
      .iter(entry.creators or {})
      :map(
        ---@param creator ZoteroCreator?
        function(creator)
          if creator ~= nil and creator.creatorType == "author" then return creator.lastName or "---" end
        end
      )
      :totable()

    local authors_str
    if #authors > max_authors then
      -- make it "et al."
      authors_str = authors[1] .. ", et al."
    else
      authors_str = table.concat(authors, ", ")
    end
    local documentation = string.format([[%s %s %s]], authors_str, title, year)
    ---@type lsp.CompletionItem
    return {
      label = entry.citekey or entry.key,
      kind = vim.lsp.protocol.CompletionItemKind.Reference,
      documentation = {
        kind = vim.lsp.protocol.MarkupKind.Markdown,
        value = documentation,
      },
      data = entry,
    }
  end


  ---@param dispatchers vim.lsp.rpc.Dispatchers
  ---@return vim.lsp.rpc.PublicClient
  local cmd = function(dispatchers)
    -- Loose adaptation of https://github.com/neovim/neovim/pull/24338
    local db = ZoteroDb:new(opts)
    if db == nil then error "zotero-ls unable to connect to Zotero databases" end

    local is_closing, request_id = false, 0

    ---@type vim.lsp.rpc.PublicClient
    return {
      request = function(method, params, callback, notify_reply_callback)
        if method == "initialize" then
          callback(nil, initializeResult)
        elseif method == "textDocument/completion" then
          callback(nil, {
            items = vim.iter(db:get_items()):map(make_compl_item):totable(),
          })
        elseif method == "completionItem/resolve" then
          callback(nil, accepted_citation(params, db))
        elseif method == "shutdown" then
          callback(nil, nil)
        end
        request_id = request_id + 1
        -- NOTE: This is needed to not accumulated "pending" `Client.requests`
        if notify_reply_callback then vim.schedule(function() pcall(notify_reply_callback, request_id) end) end
        return true, request_id
      end,
      notify = function(method, params)
        if method == "exit" then
          db:close()
          dispatchers.on_exit(0, 15)
        end
        return false
      end,
      is_closing = function() return is_closing end,
      terminate = function() is_closing = true end,
    }
  end

  return cmd
end

return M
