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

vim.schedule(function()
  require("mini.notify").setup {
    lsp_progress = {
      enable = false,
    },
  }
  vim.notify = require("mini.notify").make_notify()
  vim.api.nvim_create_user_command("Notifications", function()
    require("mini.notify").show_history()
  end, {})
end)

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "VimEnter" }, {
  once = true,
  callback = function()
    require("gitsigns").setup()
    require("dressing").setup()
    require("lualine").setup {
      options = {
        section_separators = "",
        component_separators = "",
        theme = "dayfox",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
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