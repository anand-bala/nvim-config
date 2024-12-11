---@module 'blink.cmp'

---@class BlinkVimtex : blink.cmp.Source
local M = {}

function M.new()
  return setmetatable({}, { __index = M })
end

---@class VimtexCompleter
---@field name string
---@field patterns vim.regex[]
---@field inside_braces? boolean
---@field re_context vim.regex

---@class VimtexOmniArgs
---@field type string
---@field input string
---@field context string
---@field offset? number

---@class VimCompleteItem
---@field word string
---@field abbr? string
---@field menu? string
---@field info? string
---@field kind? string

---@return VimtexCompleter[]
local function get_completers()
  local completer_types = {
    {
      -- citations
      name = "bib",
      patterns = {
        [=[\v\\%(\a*cite|Cite)\a*\*?%(\s*\[[^]]*\]|\s*\<[^>]*\>){0,2}\s*\{[^}]*$]=],
        [=[\v\\%(\a*cites|Cites)%(\s*\([^)]*\)){0,2}%(%(\s*\[[^]]*\]){0,2}\s*\{[^}]*\})*%(\s*\[[^]]*\]){0,2}\s*\{[^}]*$]=],
        [=[\v\\bibentry\s*\{[^}]*$]=],
        [=[\v\\%(text|block)cquote\*?%(\s*\[[^]]*\]){0,2}\{[^}]*$]=],
        [=[\v\\%(for|hy)\w+cquote\*?\{[^}]*\}%(\s*\[[^]]*\]){0,2}\{[^}]*$]=],
        [=[\v\\defbibentryset\{[^}]*\}\{[^}]*$]=],
        [=[\v\\\a?[vV]olcite%(\s*\[[^]]*\])?\s*\{[^}]*\}%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
      },
    },
    -- {
    --   -- \autoref
    --   -- in-document references
    --   name = "ref",
    --   patterns = {
    --     [=[\v\\v?%(auto|eq|[cC]?%(page)?|labelc)?ref%(s\*?\{[^}]*|ranges\*?\{[^,{}]*%(\}\{)?)$]=],
    --     [=[\\hyperrefs*[[^]]*$]=],
    --     [=[\\subref*?{[^}]*$]=],
    --     [=[\\nameref{[^}]*$]=],
    --   },
    --   re_context = [[\\\w*{[^}]*$]],
    -- },
    {
      -- macros that start with \
      name = "cmd",
      patterns = {
        vim.g["vimtex#re#not_bslash"] .. [[\\\a*$]],
      },
      inside_braces = false,
    },
    {
      -- environment names
      name = "env",
      patterns = {
        [=[\v\\%(begin|end)%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
      },
    },
    {
      -- filenames for \includegraphics
      name = "img",
      patterns = {
        [=[\v\\includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*$]=],
      },
    },
    {
      -- filenames for \input, \include, and \subfile
      name = "inc",
      patterns = {
        vim.g["vimtex#re#tex_input"] .. "[^}]*$",
        [[\v\\includeonly\s*\{[^}]*$]],
      },
    },
    {
      -- filenames for \includepdf
      name = "pdf",
      patterns = {
        [=[\v\\includepdf%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
      },
    },
    {

      -- filenames for \includestandalone
      name = "sta",
      patterns = {
        [=[\v\\includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
      },
    },
    {
      -- glossary \gls +++
      name = "gls",
      patterns = {
        [=[\v\\([cpdr]?(gls|Gls|GLS)|acr|Acr|ACR)\a*\s*\{[^}]*$]=],
        [=[\v\\(ac|Ac|AC)\s*\{[^}]*$]=],
      },
    },
    {
      -- packages \usepackage
      name = "pck",
      patterns = {
        [=[\v\\%(usepackage|RequirePackage)%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
        [=[\v\\PassOptionsToPackage\s*\{[^}]*\}\s*\{[^}]*$]=],
      },
    },
    {
      -- documentclasses \documentclass
      name = "doc",
      patterns = {
        [=[\v\\documentclass%(\s*\[[^]]*\])?\s*\{[^}]*$]=],
        [=[\v\\PassOptionsToClass\s*\{[^}]*\}\s*\{[^}]*$]=],
      },
    },
    {
      -- bibliography styles \bibliographystyle
      name = "bst",
      patterns = {
        [=[\v\\bibliographystyle\s*\{[^}]*$]=],
      },
    },
  }

  local compiled_completers = {}
  for _, completer in ipairs(completer_types) do
    local cmpl = vim.deepcopy(completer)
    cmpl.patterns = vim.tbl_map(function(pat)
      return vim.regex(pat)
    end, completer.patterns)
    cmpl.re_context = vim.regex(completer.re_context or [[\S*$]])
    table.insert(compiled_completers, cmpl)
  end

  return compiled_completers
end

local completers = nil

local TYPE2KIND = {
  bib = vim.lsp.protocol.CompletionItemKind.Reference,
  ref = vim.lsp.protocol.CompletionItemKind.Reference,
  cmd = vim.lsp.protocol.CompletionItemKind.Function,
  env = vim.lsp.protocol.CompletionItemKind.EnumMember,
  img = vim.lsp.protocol.CompletionItemKind.File,
  inc = vim.lsp.protocol.CompletionItemKind.File,
  pdf = vim.lsp.protocol.CompletionItemKind.File,
  sta = vim.lsp.protocol.CompletionItemKind.File,
  gls = vim.lsp.protocol.CompletionItemKind.Reference,
  pck = vim.lsp.protocol.CompletionItemKind.Module,
  doc = vim.lsp.protocol.CompletionItemKind.Class,
  bst = vim.lsp.protocol.CompletionItemKind.Module,
}

function M:get_trigger_characters()
  return { "{", ",", "[", "\\" }
end

function M:enabled()
  return vim.bo.omnifunc == "vimtex#complete#omnifunc"
end

---@param self blink.cmp.Source
---@param ctx blink.cmp.Context
---@return VimtexOmniArgs?
function M:_get_omni_args(ctx)
  if completers == nil then
    completers = get_completers()
  end
  local line = string.sub(ctx.line, 1, ctx.cursor[2])
  for _, completer in ipairs(completers) do
    for pat_num, pattern in ipairs(completer.patterns) do
      if pattern:match_str(line) then
        print("matched --> " .. completer.name .. "@" .. pat_num)
        for pos = ctx.cursor[2] - 1, 1, -1 do
          -- print("pos = " .. pos)
          -- print("line = " .. line)
          -- print("line[" .. pos .. "] = " .. line:sub(pos, pos))
          if
            vim.tbl_contains(self:get_trigger_characters(), line:sub(pos, pos))
            or line:sub(pos - 1, pos) == ", "
          then
            local ctx_start, ctx_end = completer.re_context:match_str(line)
            print("input start = " .. ctx_start .. "-" .. ctx_end)
            if ctx_start then
              local context = string.sub(line, ctx_start, ctx_end)
              return {
                name = completer.name,
                input = string.sub(line, pos),
                context = context,
                offset = pos,
              }
            end
          end
        end
      end
    end
  end
end

---@param ctx blink.cmp.Context
---@param callback fun(response?: blink.cmp.CompletionResponse)
function M:get_completions(ctx, callback)
  -- we use libuv, but the rest of the library expects to be synchronous
  callback = vim.schedule_wrap(callback)

  local args = self:_get_omni_args(ctx)
  if not args then
    return callback()
  end
  local expected_offset = vim.fn[vim.bo.omnifunc](1, "")
  assert(
    args.offset == expected_offset + 1,
    string.format("got %d expected %d", args.offset, expected_offset + 1)
  )
  ---@type (string|VimCompleteItem)[]
  local candidates =
    vim.fn["vimtex#complete#complete"](args.type, args.input, args.context)
  if not candidates then
    return callback()
  end
  print("passed --> #candidates = " .. #candidates)

  local text_edit_range = {
    start = {
      line = ctx.cursor[0],
      character = args.offset,
    },
    ["end"] = {
      line = ctx.cursor[0],
      character = ctx.cursor[1],
    },
  }

  ---@type lsp.CompletionItem[]
  local items = vim.tbl_map(
    ---@param item string|VimCompleteItem
    ---@return lsp.CompletionItem
    function(item)
      if type(item) == "string" then
        ---@type lsp.CompletionItem
        return {
          label = item,
          textEdit = {
            range = text_edit_range,
            newText = item,
          },
        }
      elseif type(item) == "table" then
        ---@type lsp.CompletionItem
        local _item = {
          label = item.abbr or item.word,
          textEdit = {
            range = text_edit_range,
            newText = item.word,
          },
          kind = TYPE2KIND[args.type],
          labelDetails = { detail = item.kind, description = item.menu },
        }
        return _item
      end
    end,
    candidates
  )
  return callback {
    items = items,
    is_incomplete_forward = false,
    is_incomplete_backward = false,
  }
end

return M
