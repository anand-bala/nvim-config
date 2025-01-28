---@module "blink.cmp"

---@class blink.cmp.VimtexSource : blink.cmp.Source
---@diagnostic disable-next-line: missing-fields
local source = {}

function source.new(_)
  local self = setmetatable({}, { __index = source })
  return self
end

function source:enabled() return (vim.g.vimtex_complete_enabled ~= 0 and vim.tbl_get(vim.b.vimtex, "complete") ~= nil) end

function source:get_trigger_characters() return { "{", ",", "[", "\\" } end

local CompletionItemKind = require("blink.cmp.types").CompletionItemKind

---@class OmniLspCheck
---@field [integer] {pattern:vim.regex,kind:lsp.CompletionItemKind}
VIMTEX_OMNI_TO_LSP_KIND = {
  { pattern = vim.regex "^\\[package\\]$", kind = CompletionItemKind.Module },
  { pattern = vim.regex "^\\[documentclass\\]$", kind = CompletionItemKind.Class },
  { pattern = vim.regex "^\\[bst files\\]$", kind = CompletionItemKind.Class },
  { pattern = vim.regex "^\\[cmd: glossaries\\]$", kind = CompletionItemKind.Reference },
  { pattern = vim.regex "^\\[gls\\]$", kind = CompletionItemKind.Reference },
  { pattern = vim.regex "^\\[cmd:.\\+\\]$", kind = CompletionItemKind.Function },
  { pattern = vim.regex "^\\[env:.\\+\\]$", kind = CompletionItemKind.Enum },
  {
    pattern = vim.regex "^\\[\\(includestandalone\\|includepdf\\|include\\|input\\|graphics\\)\\]$",
    kind = CompletionItemKind.File,
  },
}

---Find the kind of the item from the patterns
---@param kind_text string
---@return lsp.CompletionItemKind?
function VIMTEX_OMNI_TO_LSP_KIND:_find_lsp_kind(kind_text)
  for _, mapping in ipairs(self) do
    local matched = mapping.pattern:match_str(kind_text)
    if matched then return mapping.kind end
  end
end

---Get completion candidates from vimtex#complete#omnifunc
---@param ctx blink.cmp.Context
---@param callback fun(response?: blink.cmp.CompletionResponse)
---@return (fun():nil)?
function source:get_completions(ctx, callback)
  local offset_0 = vim.fn["vimtex#complete#omnifunc"](1, "")
  if type(offset_0) ~= "number" or offset_0 <= -2 then
    callback()
    ---@diagnostic disable-next-line: missing-return
    return
  end

  local cursor_before_line = string.sub(ctx.line, 1, ctx.cursor[2])
  local base = string.sub(cursor_before_line, offset_0 + 1)

  ---@type (string|vim.v.completed_item)[]?
  local result = vim.fn["vimtex#complete#omnifunc"](0, base)
  if type(result) ~= "table" then
    callback()
    ---@diagnostic disable-next-line: missing-return
    return
  end

  local text_edit_range = {
    start = {
      line = ctx.cursor[1] - 1,
      character = offset_0,
    },
    ["end"] = {
      line = ctx.cursor[1] - 1,
      character = vim.str_utfindex(ctx.line, "utf-8", ctx.cursor[2]),
    },
  }

  ---@type blink.cmp.CompletionItem[]
  local items = {}
  for _, v in ipairs(result) do
    if type(v) == "string" then
      table.insert(items, {
        label = v,
        textEdit = {
          range = text_edit_range,
          newText = v,
        },
        -- kind = CompletionItemKind.Function,
        data = { word = v },
      })
    elseif type(v) == "table" then
      assert(type(v.word) == "string")
      -- Skip if we don't have the item kind. Heuristic for citations and things
      if v.kind ~= nil and v.kind ~= "" then
        ---@type blink.cmp.CompletionItem
        ---@diagnostic disable-next-line: missing-fields
        local _item = {
          label = v.abbr or v.word --[[@as string]],
          textEdit = {
            range = text_edit_range,
            newText = v.word,
          },
          labelDetails = {
            detail = v.kind,
            description = v.menu,
          },
          kind = VIMTEX_OMNI_TO_LSP_KIND:_find_lsp_kind(v.kind) or CompletionItemKind.Function,
          documentation = v.info,
          detail = v.menu,
          data = vim.deepcopy(v),
        }

        table.insert(items, _item)
      end
    end
  end

  callback {
    is_incomplete_forward = false,
    is_incomplete_backward = false,
    items = items,
    ---@diagnostic disable-next-line: missing-return
  }
end

return source
