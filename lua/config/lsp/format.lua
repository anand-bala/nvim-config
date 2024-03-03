local map = vim.keymap.set
local command = vim.api.nvim_create_user_command
local buf_command = vim.api.nvim_buf_create_user_command

local M = {}

---@type PluginLspOpts
M.opts = nil

function M.enabled()
  return M.opts.autoformat
end

function M.enable()
  if not M.opts.autoformat then
    M.opts.autoformat = true
    vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Format" })
  end
end

function M.disable()
  if M.opts.autoformat then
    M.opts.autoformat = false
    vim.notify("Disabled format on save", vim.log.levels.INFO, { title = "Format" })
  end
end

function M.toggle()
  if M.enabled() then
    M.disable()
  else
    M.enable()
  end
end

---@param formatters LazyVimFormatters
function M.notify(formatters)
  local lines = { "# Active:" }

  for _, client in ipairs(formatters.available) do
    local line = "- **" .. client.name .. "**"
    if client.name == "null-ls" then
      line = line
        .. " ("
        .. table.concat(
          vim.tbl_map(function(f)
            return "`" .. f.name .. "`"
          end, formatters.null_ls),
          ", "
        )
        .. ")"
    end
    table.insert(lines, line)
  end

  if
    formatters.formatter_nvim ~= nil
    and not vim.tbl_isempty(formatters.formatter_nvim)
  then
    local line = "- ** formatter.nvim **"
      .. " ("
      .. table.concat(
        vim.tbl_map(function(f)
          return "`" .. f().exe .. "`"
        end, formatters.formatter_nvim),
        ", "
      )
      .. ")"
    table.insert(lines, line)
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Formatting",
    on_open = function(win)
      vim.api.nvim_set_option_value("conceallevel", 3, {
        win = win,
      })
      vim.api.nvim_set_option_value("spell", false, {
        win = win,
      })
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  })
end

--- Gets all lsp clients that support formatting.
--- When a null-ls formatter is available for the current filetype,
--- only null-ls formatters are returned.
---@param bufnr integer
---@return LazyVimFormatters
function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"]
      and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
    or {}

  -- check if we have any formatter.nvim formatters for the current filetype
  local formatter_nvim = package.loaded["formatter"]
      and require("formatter.config").formatters_for_filetype(ft)
    or {}

  ---@class LazyVimFormatters
  local ret = {
    ---@type lsp.Client[]
    available = {},
    null_ls = null_ls,
    formatter_nvim = formatter_nvim,
  }

  ---@type lsp.Client[]
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if client.supports_method "textDocument/formatting" then
      table.insert(ret.available, client)
    end
  end

  return ret
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {
  clear = true,
})

---On attach hook for formatting stuff
---@param client vim.lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if M.opts.autoformat then
          vim.lsp.buf.format()
        end
      end,
    })

    map("n", "<leader>f", function()
      vim.lsp.buf.format()
    end, {
      desc = "Format the document",
    })
    buf_command(bufnr, "Format", function()
      vim.lsp.buf.format()
    end, { desc = "Format the document", force = true })
  end
end

---@param opts PluginLspOpts
function M.setup(opts)
  M.opts = opts

  command("FormatToggle", function()
    M.toggle()
  end, { desc = "Toggle auto-format", force = true })
  command("ListFormatters", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local formatters = M.get_formatters(bufnr)
    M.notify(formatters)
  end, {
    desc = "List the formatters for this buffer",
    force = true,
  })
end

return M
