local onattach = require("config.lsp").on_attach_hook

vim.opt.textwidth = 88

vim.g.rustaceanvim = {
  server = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          features = "all",
        },
        -- Add clippy lints for Rust.
        checkOnSave = true,
        -- Use nightly for rustfmt
        rustfmt = {
          extraArgs = "+nightly",
        },
        -- Use clippy for checking
        check = {
          command = "clippy",
          features = "all",
        },
        -- Enable procedural macro support
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

onattach(function(client, buffer)
  vim.lsp.inlay_hint.enable(false, { bufnr = buffer })
end, {
  desc = "disable LSP inlay hints for Rust. Use rust-tools.",
})
