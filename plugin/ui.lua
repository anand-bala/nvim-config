if vim.g.loaded_ui_plugins then
  return
end

do
  local ok, notify = pcall(require, "notify")
  if ok then
    ---@diagnostic disable-next-line: missing-fields
    notify.setup {
      -- top_down = false,
    }
    vim.notify = notify
  end
end

do
  local ok, nightfox = pcall(require, "nightfox")
  if ok then
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
end

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufWinEnter" }, {
  once = true,
  callback = function()
    do
      local ok, gitsigns = pcall(require, "gitsigns")
      if ok then
        gitsigns.setup()
      end
    end
    do
      local ok, dressing = pcall(require, "dressing")
      if ok then
        dressing.setup()
      end
    end
    do
      local ok, which_key = pcall(require, "which-key")
      if ok then
        which_key.setup()
      end
    end
    do
      local ok, lualine = pcall(require, "lualine")
      if ok then
        lualine.setup {
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
      end
    end
    -- do
    --   local ok, mini_statusline = pcall(require, "mini.statusline")
    --   if ok then
    --     mini_statusline.setup { set_vim_settings = false }
    --   end
    -- end
    -- do
    --   local ok, mini_tabline = pcall(require, "mini.tabline")
    --   if ok then
    --     mini_tabline.setup { set_vim_settings = true }
    --   end
    -- end
  end,
  pattern = "*",
})

vim.g.loaded_ui_plugins = true
