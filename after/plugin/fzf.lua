if vim.g.loaded_fzf_plugin ~= nil then return end
vim.g.loaded_fzf_plugin = 1

local command = vim.api.nvim_create_user_command

vim.schedule(function()
  vim.cmd [[:packadd fzf-lua]]
  local actions = require "fzf-lua.actions"
  require("fzf-lua").setup {
    "borderless_full",
    defaults = {
      -- formatter = "path.filename_first",
      formatter = "path.dirname_first",
      git_icons = false,
    },
    winopts = {
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    actions = {
      files = {
        -- instead of the default action 'actions.file_edit_or_qf'
        -- it's important to define all other actions here as this
        -- table does not get merged with the global defaults
        ["default"] = actions.file_edit,
        ["enter"] = actions.file_edit_or_qf,
        ["ctrl-x"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-t"] = actions.file_tabedit,
        ["alt-q"] = actions.file_sel_to_qf,
      },
    },
    buffers = {
      keymap = { builtin = { ["<C-d>"] = false } },
      actions = { ["ctrl-x"] = false, ["ctrl-d"] = { actions.buf_del, actions.resume } },
    },
    files = {
      fzf_opts = {
        ["--history"] = vim.fs.joinpath(vim.fn.stdpath "data" --[[@as string]], "/fzf-lua-files-history"),
      },
    },
    grep = {
      fzf_opts = {
        ["--history"] = vim.fs.joinpath(vim.fn.stdpath "data" --[[@as string]], "/fzf-lua-grep-history"),
      },
    },
  }
end)

command("Helptags", "FzfLua helptags", { force = true })
command("Buffers", "FzfLua buffers", { force = true })

vim.keymap.set("n", "<C-f>", "<cmd>FzfLua files<cr>", { remap = false, desc = "Fuzzy search workspace files" })
vim.keymap.set("n", "<C-g>", "<cmd>FzfLua live_grep<cr>", { remap = false, desc = "Live grep workspace files" })
vim.keymap.set("n", "<C-b>", "<cmd>FzfLua buffers<cr>", { remap = false, desc = "Fuzzy search open buffers" })
