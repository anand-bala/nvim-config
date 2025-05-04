if vim.g.loaded_ui_plugins ~= nil then return end
vim.g.loaded_ui_plugins = 1

require("mini.icons").setup()
_G.MiniIcons.tweak_lsp_kind()
_G.MiniIcons.mock_nvim_web_devicons()
local nightfox = require "nightfox"
--- Colorscheme
---
--- # My Colorblindness simulation
---
--- Source: https://daltonlens.org/evaluating-cvd-simulation/#Generating-Ishihara-like-plates-for-self-evaluation
---
--- | Plate method           | Protan | Deutan | Tritan |
--- | ---------------------- | ------ | ------ | ------ |
--- | Brettel 1997 sRGB      | 0.4    | 0.9    | 0.1    |
--- | Vischeck (Brettel CRT) | 0.3    | 0.9    | 0.1    |
--- | Viénot 1999 sRGB       | 0.4    | 0.9    | 0.1    |
--- | Machado 2009 sRGB      | 0.4    | 0.8    | 0.1    |
nightfox.setup {
  options = {
    colorblind = {
      enable = true,
      severity = {
        protan = 0.4,
        deutan = 1.0,
      },
    },
  },
}
vim.cmd "colorscheme dayfox"

require("vim._extui").enable {}
--vim.schedule(function()
--  ---@diagnostic disable-next-line: missing-fields
--  require("notify").setup {
--    render = "wrapped-compact",
--    stages = "static",
--  }
--  vim.notify = require "notify"
--end)

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "VimEnter" }, {
  once = true,
  callback = function()
    require("gitsigns").setup()
    require("dressing").setup()
    require("bqf").setup {
      ---@diagnostic disable-next-line: missing-fields
      preview = {
        winblend = 0,
      },
    }
    require("quicker").setup()
    require("lualine").setup {
      options = {
        section_separators = "",
        component_separators = "",
        theme = "dayfox",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      tabline = {
        lualine_a = { "buffers" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" },
      },
    }
  end,
  pattern = "*",
})
