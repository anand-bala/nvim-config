local opts = {
  ensure_installed = {
    "stylua",
    "lua-language-server",
    "shellcheck",
    "shfmt",
    "shellharden",
  },
}

require("mason").setup(opts)
local mr = require "mason-registry"
mr.refresh(function()
  for _, tool in ipairs(opts.ensure_installed) do
    local p = mr.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end)
