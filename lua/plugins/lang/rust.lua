-- Setup Mason tools
local mason = {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "codelldb", "rust-analyzer" })
  end,
}

-- Setup LSP
local lsp = {
  "neovim/nvim-lspconfig",
  dependencies = { "simrat39/rust-tools.nvim"},
  opts = {
    setup = {
      rust_analyzer = function(_, opts)
        local mason_registry = require "mason-registry"
        -- rust tools configuration for debugging support
        local codelldb = mason_registry.get_package "codelldb"
        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = vim.fn.has "mac" == 1
            and extension_path .. "lldb/lib/liblldb.dylib"
          or extension_path .. "lldb/lib/liblldb.so"
        local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
          dap = {
            adapter = require("rust-tools.dap").get_codelldb_adapter(
              codelldb_path,
              liblldb_path
            ),
          },
          tools = {
            hover_actions = {
              auto_focus = false,
              border = "none",
            },
            inlay_hints = {
              auto = false,
              show_parameter_hints = true,
            },
          },
          server = {
            settings = {
              ["rust-analyzer"] = {
                cargo = {
                  features = "all",
                },
                -- Add clippy lints for Rust.
                checkOnSave = true,
                check = {
                  command = "clippy",
                  features = "all",
                },
                procMacro = {
                  enable = true,
                },
              },
            },
          },
        })
        require("rust-tools").setup(rust_tools_opts)
        return true
      end,
    },
  },
}

return {
  mason,
  lsp,
}
