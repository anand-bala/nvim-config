-- Minimal helpers for built-in terminal

if vim.g.loaded_term_helper then return end

local cmd = vim.api.nvim_create_user_command

local term_helper = {}

local default_opts = {
  vertical = true,
  size = nil,
  tab = false,
  claude = false,
}
function term_helper.open_buffer(opts)
  vim.validate("opts", opts, "table", true)
  opts = vim.tbl_extend("keep", opts or {}, default_opts)
  if opts.tab and opts.vertical then error "Can't have `tab` and `vertical` options both true" end

  local command = ""
  if opts.tab then
    command = ":tabnew"
    opts.size = nil
  elseif opts.vertical then
    command = ":vnew"
  else
    command = ":new"
  end

  if opts.size and type(opts.size) == "number" and opts.size > 0 then
    command = string.format("%d%s", opts.size, command)
  end

  vim.cmd(command)
end

function term_helper.open_term(args, opts)
  vim.validate("opts", opts, "table", true)
  opts = vim.tbl_extend("keep", opts or {}, default_opts)
  term_helper.open_buffer(opts)

  --- Default shell to use when opening the terminal
  local shell = vim.g.terminal_shell or vim.o.shell
  local prev_shell = vim.o.shell
  vim.o.shell = shell

  --- Get the current buffer number
  assert(type(args) == "string")
  vim.cmd(":terminal " .. args)
  vim.cmd ":startinsert"

  local buf = vim.api.nvim_get_current_buf()

  --- Claude uses its own ESC mapping
  if not opts.claude then
    -- Use ESC in terminal mode to switch to normal mode
    vim.keymap.set(
      "t",
      "<Esc>",
      "<C-\\><C-n>",
      { remap = true, desc = "Use ESC in terminal mode to switch to normal mode", buffer = buf }
    )
  end
  vim.o.shell = prev_shell
end

function term_helper.split_term(args, count) term_helper.open_term(args, { vertical = false, size = count }) end

function term_helper.vsplit_term(args, count) term_helper.open_term(args, { vertical = true, size = count }) end

function term_helper.tab_term(args, opts)
  opts = opts or {}
  term_helper.open_term(args, vim.tbl_deep_extend("keep", { tab = true, vertical = false }, opts))
end

cmd("Term", function(args) term_helper.split_term(args.args, args.count) end, {
  force = true,
  count = true,
  nargs = "*",
})

cmd("VTerm", function(args) term_helper.vsplit_term(args.args, args.count) end, {
  force = true,
  count = true,
  nargs = "*",
})

cmd("TTerm", function(args) term_helper.tab_term(args.args) end, {
  force = true,
  nargs = "*",
})

cmd("Claude", function() term_helper.tab_term("claude", { claude = true }) end, {
  force = true,
  desc = "Open Claude Code in a new tab",
})

-- Launch terminal at bottom of window
-- map("n", "`", "<cmd>Term<CR>", { silent = true, remap = false })
-- Create new terminal vsplit
vim.keymap.set("n", "<C-w>|", "<cmd>VTerm<CR>", { silent = true, remap = false })

vim.g.loaded_term_helper = true
