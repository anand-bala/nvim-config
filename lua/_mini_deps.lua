do
  local path_package = vim.fn.stdpath "data" .. "/site/"
  local mini_path = path_package .. "pack/deps/start/mini.deps"
  if not vim.loop.fs_stat(mini_path) then
    vim.cmd 'echo "Installing `mini.deps`" | redraw'
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.deps",
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd "packadd mini.deps | helptags ALL"
    vim.cmd 'echo "Installed `mini.deps`" | redraw'
  end
  require("mini.deps").setup { path = { package = path_package } }
end

local add = MiniDeps.add
local later = MiniDeps.later

add "nvim-lua/plenary.nvim"
add "tpope/vim-obsession"
--add("dhruvasagar/vim-prosession")
add "direnv/direnv.vim"

-- add {
--   source = "benlubas/molten-nvim",
--   hooks = {
--     post_checkout = function()
--       vim.cmd ":UpdateRemotePlugins"
--     end,
--   },
--   depends = {
--     "3rd/image.nvim",
--   },
-- }

--
local later_plugins = {
  "tpope/vim-commentary",
  "sindrets/diffview.nvim",
  "dstein64/vim-startuptime",
}
for _, plugin in ipairs(later_plugins) do
  later(function()
    add(plugin)
  end)
end
