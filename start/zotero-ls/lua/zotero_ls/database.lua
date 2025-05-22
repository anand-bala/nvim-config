local sqlite = require "sqlite.db"

---@class ZoteroDb
---@field zotero_db sqlite_db
---@field bbt_db sqlite_db
local ZoteroDb = {}
local db_meta = { __index = ZoteroDb }

---@param path string
---@return sqlite_db?
local function connect(path)
  path = vim.fn.expand(path)
  local ok, db = pcall(sqlite.open, sqlite, "file:" .. path .. "?immutable=1", { open_mode = "ro" })
  if ok then
    return db
  else
    vim.notify_once(("[zotero] could not open database at %s."):format(path))
    return nil
  end
end

---@param opts {zotero_db_path: string, better_bibtex_db_path: string}
---@return ZoteroDb?
function ZoteroDb:new(opts)
  vim.validate("opts", opts, "table")
  vim.validate("opts.zotero_db_path", opts.zotero_db_path, "string")
  vim.validate("opts.better_bibtex_db_path", opts.better_bibtex_db_path, "string")

  local zotero_db = connect(opts.zotero_db_path)
  local better_bibtex_db = connect(opts.better_bibtex_db_path)

  if zotero_db == nil or better_bibtex_db == nil then return nil end

  return setmetatable({
    zotero_db = zotero_db,
    bbt_db = better_bibtex_db,
  }, db_meta)
end

function ZoteroDb:close()
  local closed_zotero_db = self.zotero_db:close()
  local closed_bbt = self.bbt_db:close()
  return closed_bbt and closed_zotero_db
end

local query_bbt = [[
  SELECT
    itemKey, citationKey
  FROM
    citationkey
]]

local query_items = [[
    SELECT
      DISTINCT items.key, items.itemID,
      fields.fieldName,
      parentItemDataValues.value,
      itemTypes.typeName
    FROM
      items
      INNER JOIN itemData ON itemData.itemID = items.itemID
      INNER JOIN itemDataValues ON itemData.valueID = itemDataValues.valueID
      INNER JOIN itemData as parentItemData ON parentItemData.itemID = items.itemID
      INNER JOIN itemDataValues as parentItemDataValues ON parentItemDataValues.valueID = parentItemData.valueID
      INNER JOIN fields ON fields.fieldID = parentItemData.fieldID
      INNER JOIN itemTypes ON itemTypes.itemTypeID = items.itemTypeID
]]
local query_creators = [[
    SELECT
      DISTINCT items.key,
      creators.firstName,
      creators.lastName,
      itemCreators.orderIndex,
      creatorTypes.creatorType
    FROM
      items
      INNER JOIN itemData ON itemData.itemID = items.itemID
      INNER JOIN itemCreators ON itemCreators.itemID = items.itemID
      INNER JOIN creators ON creators.creatorID = itemCreators.creatorID
      INNER JOIN creatorTypes ON itemCreators.creatorTypeID = creatorTypes.creatorTypeID
    ]]

---@class ZoteroCreator
---@field firstName? string
---@field lastName? string
---@field creatorType "author"|string

---@class ZoteroItem
---@field citekey? string
---@field key string
---@field creators? ZoteroCreator[]
---@field year? string
---@field date? string
---@field [string] string?

---@return ZoteroItem[]
function ZoteroDb:get_items()
  local items = {}
  local raw_items = {}
  local sql_items = self.zotero_db:eval(query_items)
  assert(type(sql_items) == "table")
  local sql_creators = self.zotero_db:eval(query_creators)
  assert(type(sql_creators) == "table")
  local sql_bbt = self.bbt_db:eval(query_bbt)
  assert(type(sql_bbt) == "table")

  if sql_items == nil or sql_creators == nil or sql_bbt == nil then
    vim.notify_once("[zotero] could not query database.", vim.log.levels.WARN, {})
    return {}
  end
  local bbt_citekeys = {}
  for _, v in pairs(sql_bbt) do
    bbt_citekeys[v.itemKey] = v.citationKey
  end

  for _, v in pairs(sql_items) do
    if raw_items[v.key] == nil then raw_items[v.key] = { creators = {}, key = v.key } end
    raw_items[v.key][v.fieldName] = v.value
    raw_items[v.key].itemType = v.typeName
    if v.fieldName == "DOI" then raw_items[v.key].DOI = v.value end
  end

  for _, v in pairs(sql_creators) do
    if raw_items[v.key] ~= nil then
      raw_items[v.key].creators[v.orderIndex + 1] =
        { firstName = v.firstName, lastName = v.lastName, creatorType = v.creatorType }
    end
  end

  for key, item in pairs(raw_items) do
    local citekey = bbt_citekeys[key]
    if citekey ~= nil then
      item.citekey = citekey
      table.insert(items, item)
    end
  end
  return items
end

return ZoteroDb
