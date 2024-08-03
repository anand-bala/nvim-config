vim.schedule(function()
  local mason_opts = {
    ensure_installed = {
      "stylua",
      "lua-language-server",
      "shellcheck",
      "shfmt",
      "shellharden",
    },
  }
  local mason = require "mason"
  mason.setup(mason_opts)
  local mr = require "mason-registry"
  mr.refresh(function()
    for _, tool in ipairs(mason_opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end)

  local setup = require("config.lsp.servers").setup_lsp_config
  require("mason-lspconfig").setup_handlers { setup }
end)

vim.schedule(function()
  local opts = require "config.lsp.servers" or {}

  local servers = opts.servers
  local setup = opts.setup_lsp_config

  for server, server_opts in pairs(servers) do
    if server_opts then
      setup(server)
    end
  end
end)

-- LSP default on_attach hooks
require("config.lsp").on_attach_hook(
  require("config.lsp").keymaps,
  { desc = "LSP: setup default keymaps", group = "LspDefaultKeymaps" }
)

local has_compl, compl = pcall(require, "lsp_compl")
if has_compl then
  local luasnip = require "luasnip"
  compl.expand_snippet = luasnip.lsp_expand
  require("config.lsp").on_attach_hook(compl.attach)
  vim.keymap.set("i", "<CR>", function()
    return compl.accept_pum() and "<c-y>" or "<CR>"
  end, { expr = true })
  vim.keymap.set("i", "<C-p>", function()
    return compl.accept_pum() and "<C-p>" or compl.trigger_completion()
  end)
  vim.keymap.set("i", "<C-n>", function()
    return compl.accept_pum() and "<C-n>" or compl.trigger_completion()
  end)
  vim.keymap.set({ "i", "s" }, "<C-j>", function()
    -- Backward
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    end
  end)
  vim.keymap.set({ "i", "s" }, "<C-k>", function()
    -- Forward
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    end
  end)
end
