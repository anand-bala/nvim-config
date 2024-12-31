local M = {}

local has_mason, mason_registry = pcall(require, "mason-registry")
local has_masonlsp, mason_lspconfig = pcall(require, "mason-lspconfig")

---Install tool using mason, if mason is present
---@param tools string[]
function M.mason_install(tools)
  if not has_mason then
    return
  end
  local show = vim.schedule_wrap(function(msg)
    vim.notify(msg, vim.log.levels.INFO, { title = "Mason" })
  end)

  local show_error = vim.schedule_wrap(function(msg)
    vim.notify(msg, vim.log.levels.ERROR, { title = "Mason" })
  end)

  mason_registry.refresh(function()
    for _, tool in ipairs(tools) do
      if has_masonlsp then
        tool = mason_lspconfig.get_mappings().lspconfig_to_mason[tool] or tool
      end
      local pkg = mason_registry.get_package(tool)
      if not pkg:is_installed() then
        show(string.format("%s: installing", pkg.name))
        pkg:once("install:success", function()
          show(string.format("%s: successfully installed", pkg.name))
        end)
        pkg:once("install:failed", function()
          show_error(string.format("%s: failed to install", pkg.name))
        end)
        pkg:install()
      end
    end
  end)
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
    if type(formatters_by_ft) == "function" then
      formatters_by_ft = formatters_by_ft(bufnr)
    end
    for _, fmt in ipairs(formatters_by_ft) do
      assert(type(fmt) == "string")
      local fmt_config = conform.get_formatter_info(fmt)
      tools[fmt] = fmt_config
    end
  end

  -- check lsp stuff
  for name in vim.spairs(vim.lsp._enabled_configs) do
    local config = vim.lsp._resolve_config(name)
    if
      vim.tbl_contains(config.filetypes or {}, ft)
      and type(config.cmd) == "table"
      and config.cmd[1] ~= nil
    then
      tools[name] = {
        command = config.cmd[1],
        available = vim.fn.executable(config.cmd[1]) == 1,
      }
    end
  end

  return tools
end

--- Wrapper to add `on_attach` hooks for LSP
---@param on_attach fun(client:vim.lsp.Client, buffer:integer)
---@param opts? {desc?:string,once?:boolean,group?:integer|string}
function M.on_attach_hook(on_attach, opts)
  opts = opts or {}
  if opts["group"] ~= nil and type(opts.group) == "string" then
    opts.group = vim.api.nvim_create_augroup(opts.group --[[@as string]], {})
  end
  vim.api.nvim_create_autocmd(
    "LspAttach",
    vim.tbl_extend("force", opts, {
      callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil then
          on_attach(client, buffer)
        end
      end,
    })
  )
end

---@param name string
---@param override? vim.lsp.Config
function M.lsp_config(name, override)
  return vim.tbl_deep_extend(
    "keep",
    override or {},
    require("lspconfig.configs." .. name).default_config
  )
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
  if maybe_root == nil then
    return
  end
  if vim.uv.fs_stat(vim.fs.joinpath(maybe_root, ".jj")) then
    -- Jujutsu project
    if vim.fn.executable "jj" == 1 then
      return vim.trim(vim.system({ "jj", "workspace", "root" }):wait().stdout)
        or maybe_root
    end
  elseif vim.uv.fs_stat(vim.fs.joinpath(maybe_root, ".git")) then
    -- Git project
    -- Current root could be within a submodule, so we first check for submodule
    -- parent module.
    local maybe_submodule_root = vim.trim(
      vim
        .system({ "git", "rev-parse", "--show-superproject-working-tree" })
        :wait().stdout
    ) or ""
    if maybe_submodule_root == "" then
      -- we are not in a submodule, so just run git rev-parse --show-toplevel
      return vim.system({ "git", "rev-parse", "--show-toplevel" }):wait().stdout
        or maybe_root
    else
      return maybe_submodule_root
    end
  end
  -- just return root as is
  return maybe_root
end

return M
