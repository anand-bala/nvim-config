local command = vim.api.nvim_create_user_command

vim.schedule(function()
  vim.cmd [[:packadd fzf-lua]]
  require("fzf-lua").setup {
    "borderless_full",
    defaults = {
      -- formatter = "path.filename_first",
      formatter = "path.dirname_first",
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
  }
end)

command("Helptags", "FzfLua helptags", { force = true })
command("Buffers", "FzfLua buffers", { force = true })

vim.keymap.set("n", "<C-f>", "<cmd>FzfLua files<cr>", { remap = false })
vim.keymap.set("n", "<C-g>", "<cmd>FzfLua live_grep<cr>", { remap = false })
vim.keymap.set("n", "<C-b>", "<cmd>FzfLua buffers<cr>", { remap = false })
