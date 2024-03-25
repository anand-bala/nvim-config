if vim.g.loaded_ui_plugins then
  return
end

do
  local notify = require "notify"
  ---@diagnostic disable-next-line: missing-fields
  notify.setup {
    top_down = false,
    max_width = 50,
    render = "wrapped-compact",
  }
  vim.notify = notify
end

do
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
end

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWinEnter" }, {
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

vim.g.loaded_ui_plugins = true
