local M = {}

local has_mason, mason_registry = pcall(require, "mason-registry")

---Install tool using mason, if mason is present
---@param tools string[]
function M.mason_install(tools)
  if has_mason then
    mason_registry.refresh(function()
      for _, tool in ipairs(tools) do
        local pkg = mason_registry.get_package(tool)
        if not pkg:is_installed() then
          pkg:install()
        end
      end
    end)
  end
end

---Install tool by filetype using mason, is mason is present

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

return M
