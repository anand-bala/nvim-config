require "astronauta.keymap"

--- Keybindings for nvim
local cmd = vim.cmd
local nnoremap = vim.keymap.nnoremap
local vnoremap = vim.keymap.vnoremap
local inoremap = vim.keymap.inoremap
local tnoremap = vim.keymap.tnoremap
local nmap = vim.keymap.nmap
local xmap = vim.keymap.xmap

-- First, we set the leader character.
-- Personally, I like backslash
vim.g.mapleader = "\\"

-- shifting visual block should keep it selected
vnoremap { "<", "<gv" }
vnoremap { ">", ">gv" }

-- go up/down on visual line
nnoremap { "<Down>", "gj" }
nnoremap { "<Up>", "gk" }
vnoremap { "<Down>", "gj" }
vnoremap { "<Up>", "gk" }
inoremap { "<Down>", "<C-o>gj" }
inoremap { "<Up>", "<C-o>gk" }

---[[ Searching stuff
nnoremap {
  "<C-f>",
  function()
    require("telescope.builtin").find_files { follow = true, hidden = true }
  end,
}
nnoremap { "<C-g>", "<cmd>Telescope live_grep<cr>" }
cmd [[command! Helptags Telescope help_tags]]
cmd [[command! Buffers  Telescope buffers]]
-- ]]

inoremap { "<C-p>", "compe#complete()", silent = true, expr = true }
inoremap { "<CR>", "compe#confirm('<CR>')", silent = true, expr = true }
inoremap { "<C-e>", "compe#close('<C-e>')", silent = true, expr = true }

---[[ Floating Terminal
nnoremap { "<leader>ft", "<cmd>FloatermToggle<CR>", silent = true }
tnoremap { "<leader>ft", "<C-\\><cmd>FloatermToggle<CR>", silent = true }

-- Escape out of terminal mode to normal mode
tnoremap { "<Esc>", "<C-\\><C-n>", silent = true }

-- Launch terminal at bottom of window
nnoremap { "`", "<cmd>FloatermNew --height=0.2 --wintype=split<CR>", silent = true }

-- Create new terminal vsplit
nnoremap { "<C-w>|", "<cmd>FloatermNew --width=0.5 --wintype=vsplit<CR>", silent = true }

-- ]]

---[[ Aligning
nmap { "ga", "<Plug>(EasyAlign)" }
xmap { "ga", "<Plug>(EasyAlign)" }
---]

local utils = require "_utils"
local augroup = utils.create_augroup

-- augroup("tex_keymaps", {
--   [[FileType tex,latex lua require"_keymaps/tex"]],
-- })
