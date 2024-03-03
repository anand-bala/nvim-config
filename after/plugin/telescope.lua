if vim.g.loaded_telescope_settings then
  return
end
vim.g.loaded_telescope_settings = true

local command = vim.api.nvim_create_user_command

--- Fuzzy search

--- Mappings for telescope.nvim
local function telescope_mappings()
  local mappings = {
    i = {
      ["<C-u>"] = false,
      ["<C-d>"] = false,
      ["<C-Down>"] = require("telescope.actions").cycle_history_next,
      ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
    },
  }
  return mappings
end

local opts = {
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      vertical = { prompt_position = "top" },
      horizontal = { prompt_position = "top" },
    },
    path_display = { truncate = 3 },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    mappings = telescope_mappings(),
    vimgrep_arguments = {
      "rg",
      "--hidden",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--hidden", "-L", "--type", "file" },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}

local ok, telescope = pcall(require, "telescope")
if ok then
  telescope.setup(opts)
  pcall(telescope.load_extension, "fzf")
  if pcall(telescope.load_extension, "prosession") then
    vim.api.nvim_create_user_command(
      "Sessions",
      "Telescope prosession",
      { force = true }
    )
  end

  command("Helptags", "Telescope help_tags", { force = true })
  command("Buffers", "Telescope buffers", { force = true })

  vim.keymap.set("n", "<C-f>", "<cmd>Telescope find_files<cr>", { remap = false })
  vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<cr>", { remap = false })
  vim.keymap.set("n", "<C-b>", "<cmd>Telescope buffers<cr>", { remap = false })
end
