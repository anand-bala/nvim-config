local util = require "lspconfig/util"

local function buildConfig()
  local check_exe = vim.fn.executable

  if check_exe "latexmk" then
    return {
      onSave = false,
      executable = "latexmk",
      args = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
    }
  elseif check_exe "tectonic" then
    return {
      onSave = false,
      executable = "tectonic",
      args = { "--synctex", "--keep-logs", "--keep-intermediates" },
    }
  end
end

local function forwardSearchConfig()
  local has = vim.fn.has
  local check_exe = vim.fn.executable
  if has "unix" then
    if check_exe "zathura" then
      return {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      }
    end
  elseif has "win32" or has "wsl" or (has "unix" and os.getenv "WSLENV") then
    return {
      executable = "SumatraPDF.exe",
      args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" },
    }
  end
end

local conf = {
  root_dir = function(fname)
    return util.root_pattern { "root.tex", "main.tex", ".latexmkrc" }(fname)
      or vim.fn.getcwd()
  end,
  single_file_support = false,
  settings = {
    texlab = {
      build = buildConfig(),
      forwardSearch = forwardSearchConfig(),
      latexFormatter = "texlab",
      latexindent = { modifyLineBreaks = true },
    },
  },
}

return conf
