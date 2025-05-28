local disabled_plugins = vim
  .iter({
    "autopep8",
    "flake8",
    "mccabe",
    "pycodestyle",
    "pydocstyle",
    "pyflakes",
    "pylint",
    "yapf",
  })
  :fold({}, function(dict, plugin)
    dict[plugin] = { enabled = false }
    return dict
  end)

local enabled_plugins = vim
  .iter({
    "rope_autoimport",
  })
  :fold({}, function(dict, plugin)
    dict[plugin] = { enabled = true }
    return dict
  end)

---@type vim.lsp.Config
return {
  cmd = { "uv", "run", "--with", "python-lsp-server[rope],pylsp-mypy", "pylsp" },
  filetypes = { "python" },
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
    ".jj",
  },
  settings = {
    pylsp = {
      plugins = vim.tbl_deep_extend("force", disabled_plugins, enabled_plugins, {}),
    },
  },
}
