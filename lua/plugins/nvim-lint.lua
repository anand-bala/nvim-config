require("lint").linters_by_ft = {
  python = {
    -- "ruff",
    "mypy",
  },
  bash = {
    "shellcheck",
  },
  cmake = {
    "cmakelint",
  },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
