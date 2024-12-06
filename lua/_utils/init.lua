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

return M
