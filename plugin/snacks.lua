if vim.g.loaded_snacks_plugin ~= nil then return end
vim.g.loaded_snacks_plugin = 1

local command = vim.api.nvim_create_user_command

vim.schedule(function()
  local snacks = require "snacks"

  snacks.setup {
    picker = {
      enabled = true,
      win = {
        input = {
          b = {
            minicompletion_disable = true,
          },
        },
      },
    },
    input = { enabled = true },
    styles = {
      input = {
        relative = "cursor",
        row = -3,
        col = 0,
        b = {
          minicompletion_disable = true,
        },
      },
    },
  }
end)

command("Helptags", function() Snacks.picker.help() end, { force = true, desc = "Help" })
command("Buffers", function() Snacks.picker.buffers() end, { force = true, desc = "Buffers" })

vim.keymap.set(
  "n",
  "<C-f>",
  function()
    Snacks.picker.files {
      show_empty = false,
      ignored = false,
    }
  end,
  { remap = false, desc = "Fuzzy search workspace files" }
)
vim.keymap.set("n", "<C-g>", function() Snacks.picker.grep() end, { remap = false, desc = "Live grep workspace files" })
vim.keymap.set(
  "n",
  "<C-b>",
  function() Snacks.picker.buffers() end,
  { remap = false, desc = "Fuzzy search open buffers" }
)
