if vim.g.loaded_ui_plugins then
  return
end
local add = MiniDeps.add
local now = MiniDeps.now
local later = MiniDeps.later

add "nvim-tree/nvim-web-devicons"

add "echasnovski/mini.notify"
later(function()
  require("mini.notify").setup {
    lsp_progress = {
      -- enable = false,
    },
  }
  vim.notify = require("mini.notify").make_notify()
end)

--add "rcarriga/nvim-notify"
--now(function()
--  local notify = require "notify"
--  ---@diagnostic disable-next-line: missing-fields
--  notify.setup {
--    top_down = false,
--    max_width = 50,
--    render = "wrapped-compact",
--  }
--  vim.notify = notify
--end)

add "EdenEast/nightfox.nvim"
now(function()
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
end)

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWinEnter" }, {
  once = true,
  callback = function()
    add "lewis6991/gitsigns.nvim"
    add "stevearc/dressing.nvim"
    add "nvim-lualine/lualine.nvim"
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

vim.g.loaded_ui_plugins = true
