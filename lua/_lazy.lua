-- Setup lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- -- Load lazy.nvim plugins
-- require("lazy").setup("plugins", {
--   defaults = { lazy = true },
--   install = { colorscheme = { "dayfox" } },
--   checker = { enabled = true, notify = false },
--   change_detection = {
--     -- automatically check for config file changes and reload the ui
--     enabled = true,
--     notify = false, -- get a notification when changes are found
--   },
--   performance = {
--     cache = {
--       enabled = true,
--       -- disable_events = {},
--     },
--     rtp = {
--       disabled_plugins = {
--         -- "gzip",
--         -- "matchit",
--         -- "matchparen",
--         "netrwPlugin",
--         "tarPlugin",
--         "tohtml",
--         "tutor",
--         -- "zipPlugin",
--       },
--     },
--   },
-- })
--
