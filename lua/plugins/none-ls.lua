local null_ls = require "null-ls"

local sources = {
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.taplo,
  null_ls.builtins.formatting.isort,
  null_ls.builtins.formatting.black,
  null_ls.builtins.formatting.yamlfmt.with {
    extra_args = {
      "-formatter",
      "-indent=2,retain_line_breaks=true",
    },
  },
  null_ls.builtins.formatting.shfmt,
  null_ls.builtins.formatting.latexindent.with {
    extra_args = { "-m", "-l" },
  },
  null_ls.builtins.diagnostics.mypy,
  null_ls.builtins.diagnostics.shellcheck,
  null_ls.builtins.diagnostics.cmake_lint,
}

null_ls.setup {
  sources = sources,
}
