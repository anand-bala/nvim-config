local notify = require "notify"
---@diagnostic disable-next-line: missing-fields
notify.setup {
  -- top_down = false,
}
vim.notify = notify
