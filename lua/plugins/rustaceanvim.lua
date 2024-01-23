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
