local M = {}

---@class omnifunk.Config
local default_config = {
  ---Delay (debounce type, in ms) between certain Neovim event and action.
  ---This can be used to (virtually) disable certain automatic actions by
  ---setting very high delay time (like 10^7).
  ---@type { completion?: integer, popup?: integer }
  delay = { completion = 100, popup = 100 },
}

---@class omnifunk.Omnifunk
---@field config omnifunk.Config
---@field _cache? vim.CompletionFunc[]
local Omnifunk = {
  config = vim.deepcopy(default_config),
  completion = {
    timer = vim.uv.new_timer(),
  },
}

---@class vim.CompletionItem
---@field word string The text that will be inserted
---@field abbr? string Abbreviation of `word`; when not empty it ois used in the menu instead of `word`
---@field menu? string Extra text for the popup meny, displayed after `word` or `abbr`
---@field info? string More information about the item, can be displayed in a preview window
---@field kind? string Type of the completion
---@field icase? 0|1 when non-zero, a
---@field equal? 0|1 when non-zero, always treat this item to be equal when comparing. Which means, "equal=1" disables filtering of this item.
---@field dup? 0|1 when non-zero this match will be added even when an item with the same word is already present. empty		when non-zero this match will be added even when it is an empty string
---@field user_data? any custom data which is associated with the item and available in |v:completed_item|; it can be any type; defaults to an empty string
---@field abbr_hlgroup? string	an additional highlight group whose attributes are combined with |hl-PmenuSel| and |hl-Pmenu| or |hl-PmenuMatchSel| and |hl-PmenuMatch| highlight attributes in the popup menu to apply cterm and gui properties (with higher priority) like strikethrough to the completion items abbreviation
---@field kind_hlgroup? string	an additional highlight group specifically for setting the highlight attributes of the completion kind. When this field is present, it will override the |hl-PmenuKind| highlight group, allowing for the customization of ctermfg and guifg properties for the completion kind
---@field match? any	See "matches" in |complete_info()|.

---@alias vim.CompletionFunc fun(findstart:integer|boolean,base:string?):integer|string[]|vim.CompletionItem[]

---@class omnifunk.SourceSpec
---@field [1] string|vim.CompletionFunc
---@field ft string[]?

---@param opts? omnifunk.Config
function Omnifunk:set_config(opts) self.config = vim.tbl_deep_extend("keep", opts or {}, self.config) end

function Omnifunk:reset_default_config() self.config = vim.deepcopy(default_config) end

function Omnifunk:is_disabled() return vim.g.omnifunk_disable == true or vim.b.omnifunk_disable == true end

function Omnifunk:start()
  if self:is_disabled() then return end

  self.completion.timer:stop()
end

---@param opts? omnifunk.Config
function M.setup(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, default_config)
  vim.validate("opts", opts, "table")
  vim.validate("opts.delay", opts.delay, "table")
  local _positive_ms = function(v) return v == math.floor(v) and v > 0 end
  vim.validate("opts.delay.completion", opts.delay.completion, _positive_ms, "positive integer")
  vim.validate("opts.delay.popup", opts.delay.popup, _positive_ms, "positive integer")
  Omnifunk:set_config(opts)
end

function M.start() end

return M
