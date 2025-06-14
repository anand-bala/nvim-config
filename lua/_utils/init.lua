local M = {}

--- Get the list of all tools (LSPs and conform.nvim formatters) configured
---@return table<string, {command: string, available: boolean}>
function M.get_all_configured_tools()
  --- list of tools configured for current buffer
  ---@type table<string,{ command: string, available: boolean }>
  local tools = {}

  -- check conform first
  local has_conform, conform = pcall(require, "conform")
  if has_conform then
    local formatters = conform.list_all_formatters()
    for _, fmt in ipairs(formatters) do
      tools[fmt.name] = fmt
    end
  end

  -- check lsp stuff
  for name in vim.spairs(vim.lsp._enabled_configs) do
    local config = (vim.lsp._resolve_config and vim.lsp._resolve_config(name)) or vim.lsp.config[name]
    if type(config.cmd) == "table" and config.cmd[1] ~= nil then
      tools[name] = {
        command = config.cmd[1],
        available = vim.fn.executable(config.cmd[1]) == 1,
      }
    end
  end

  return tools
end

--- Get the list of tools (LSPs and conform.nvim formatters) configured in the given
--- buffer (default: current buffer).
---@param bufnr? integer
---@return table<string, {command: string, available: boolean}>
function M.get_configured_tools(bufnr)
  vim.validate("bufnr", bufnr, "number", true)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  --- list of tools configured for current buffer
  ---@type table<string,{ command: string, available: boolean }>
  local tools = {}

  -- check conform first
  local has_conform, conform = pcall(require, "conform")
  if has_conform then
    local formatters_by_ft = conform.formatters_by_ft[ft] or {}
    if type(formatters_by_ft) == "function" then formatters_by_ft = formatters_by_ft(bufnr) end
    for _, fmt in ipairs(formatters_by_ft) do
      assert(type(fmt) == "string")
      local fmt_config = conform.get_formatter_info(fmt)
      tools[fmt] = fmt_config
    end
  end

  -- check lsp stuff
  for name in vim.spairs(vim.lsp._enabled_configs) do
    local config = (vim.lsp._resolve_config and vim.lsp._resolve_config(name)) or vim.lsp.config[name]
    if vim.tbl_contains(config.filetypes or { ft }, ft) and type(config.cmd) == "table" and config.cmd[1] ~= nil then
      tools[name] = {
        command = config.cmd[1],
        available = vim.fn.executable(config.cmd[1]) == 1,
      }
    end
  end

  return tools
end

---@param name string
---@param override? vim.lsp.Config
function M.lsp_config(name, override)
  return vim.tbl_deep_extend("force", require("lspconfig.configs." .. name).default_config, override or {})
end

--- Since I use jujutsu or git exclusively, this function checks for the project root
--- marked by jj or git.
---
--- Tries to be resilient to submodules/workspaces
---
---@param source? string Path of file/directory to find the root for
---@returns string|nil
function M.get_vcs_root(source)
  source = source or vim.fn.getcwd()
  local maybe_root = vim.fs.root(source, { ".jj", ".git" })
  if maybe_root == nil then return end
  if vim.uv.fs_stat(vim.fs.joinpath(maybe_root, ".jj")) then
    -- Jujutsu project
    if vim.fn.executable "jj" == 1 then
      return vim.trim(vim.system({ "jj", "workspace", "root" }):wait().stdout) or maybe_root
    end
  elseif vim.uv.fs_stat(vim.fs.joinpath(maybe_root, ".git")) then
    -- Git project
    -- Current root could be within a submodule, so we first check for submodule
    -- parent module.
    local maybe_submodule_root = vim.trim(
      vim.system({ "git", "rev-parse", "--show-superproject-working-tree" }):wait().stdout
    ) or ""
    if maybe_submodule_root == "" then
      -- we are not in a submodule, so just run git rev-parse --show-toplevel
      return vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout or maybe_root
    else
      return maybe_submodule_root
    end
  end
  -- just return root as is
  return maybe_root
end

return M
