---@diagnostic disable: missing-fields

local lspconfig_util = require "lspconfig.util"

--- Configure each server and merge it with the `opts` table in for `lspconfig`.
---@class PluginLspOpts
local M = {
  --- LSP Server Settings
  ---@type table<string,vim.lsp.ClientConfig>
  servers = {},

  --- Additional custom setup for LSP servers.
  --- The associated function should return `true` if you don't want this server to be
  --- setup with `lspconfig`.
  ---
  --- Example to setup with typescript.nvim
  --- ```lua
  --- tsserver = function(_, opts)
  ---   require("typescript").setup({ server = opts })
  ---   return true
  --- end,
  --- ```
  --- Specify * to use this function as a fallback for any server
  --- ```lua
  --- ["*"] = function(server, opts) end,
  --- ```
  ---
  ---@type table<string, fun(server:string, opts:vim.lsp.ClientConfig):boolean?>
  setup = {},

  --- add any global capabilities here
  capabilities = {},
  --- options for vim.lsp.buf.format
  --- `bufnr` and `filter` is handled by the LazyVim formatter,
  --- but can be also overridden when specified
  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },
}

M.servers = {
  jsonls = {},
  yamlls = {
    settings = {
      redhat = { telemetry = { enabled = false } },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          -- path = vim.split(package.path, ";"),
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          -- globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files and plugins
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        window = {
          -- progressBar = false,
        },
      },
    },
  },
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          diagnosticMode = "workspace",
        },
      },
    },
  },
  -- basedpyright = {
  --   settings = {
  --     pyright = {
  --       disableOrganizeImports = true,
  --     },
  --     python = {
  --       analysis = {
  --         diagnosticMode = "workspace",
  --       },
  --     },
  --   },
  -- },
  -- pylyzer = {},
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       configurationSources = { "flake8" },
  --       plugins = {
  --         autopep8 = { enabled = false },
  --         yapf = { enabled = false },
  --         pycodestyle = { enabled = false },
  --         mccabe = { enabled = false },
  --         flake8 = { enabled = true },
  --         pyflakes = { enabled = false },
  --         rope_autoimport = { enabled = false },
  --         jedi_completion = { enabled = false },
  --       },
  --     },
  --   },
  --   capabilities = {
  --     formattingProvider = false,
  --   },
  -- },
  ruff = {
    capabilities = {
      hoverProvider = false,
    },
  },
  texlab = {
    ---@diagnostic disable-next-line: assign-type-mismatch
    root_dir = function(fname)
      return lspconfig_util.root_pattern(".latexmkrc", "latexindent.yaml")(fname)
        or lspconfig_util.find_git_ancestor(fname)
    end,
    on_attach = function(_, bufnr)
      -- Setup Texlab keymaps
      vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
        silent = false,
        buffer = bufnr,
        remap = false,
      })
      vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
        silent = false,
        buffer = bufnr,
        remap = false,
      })
    end,
    settings = {
      texlab = {
        bibtexFormatter = "none",
        latexFormatter = "none",
        latexindent = {
          modifyLineBreaks = true,
        },
        inlayHints = {
          labelReferences = false,
        },
      },
    },
  },
  taplo = {
    filetypes = { "toml" },
    -- IMPORTANT: this is required for taplo LSP to work in non-git repositories
    ---@diagnostic disable-next-line: assign-type-mismatch
    root_dir = require("lspconfig.util").root_pattern("*.toml", ".git"),
    single_file_support = true,
  },
  esbonio = {
    init_options = {
      sphinx = {
        srcDir = "${confDir}",
      },
    },
  },
  ltex = {
    filetypes = { "latex", "tex", "bib", "markdown", "gitcommit" },
    settings = {
      ltex = {
        enabled = { "latex", "tex", "bib", "markdown" },
        language = "en",
        diagnosticSeverity = "information",
        sentenceCacheSize = 2000,
        checkFrequency = "save",
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en",
        },
        disabledRules = {
          en = { "EN_QUOTES" },
        },
        --dictionary = (function()
        --  -- For dictionary, search for files in the runtime to have
        --  -- and include them as externals the format for them is
        --  -- dict/{LANG}.txt
        --  --
        --  -- Also add dict/default.txt to all of them
        --  local files = {}
        --  for _, file in ipairs(vim.api.nvim_get_runtime_file("dict/*", true)) do
        --    local lang = vim.fn.fnamemodify(file, ":t:r")
        --    local fullpath = vim.fs.normalize(file)
        --    if lang ~= nil then
        --      files[lang] = { ":" .. fullpath }
        --    end
        --  end

        --  if files.default then
        --    for lang, _ in pairs(files) do
        --      if lang ~= "default" then
        --        vim.list_extend(files[lang], files.default)
        --      end
        --    end
        --    files.default = nil
        --  end
        --  return files
        --end)(),
      },
    },
  },
}

M.setup = {
  rust_analyzer = function(_, _)
    return true
  end,
  texlab = function(_, opts)
    local texlab_helpers = require "config.lsp.texlab"

    opts.settings.texlab.build = texlab_helpers.build_config()
    opts.settings.texlab.forwardSearch = texlab_helpers.forward_search()
  end,

  -- ltex = function(_, opts)
  --   opts = vim.tbl_deep_extend("force", opts or {}, {
  --     use_spellfile = true, -- Uses the value of 'spellfile' as an external file when checking the document
  --     window_border = "single", -- How the border should be rendered
  --     commands = {}, -- TODO: there is an error here
  --   })
  --   require("config.lsp.ltex").setup(opts)
  --   return true
  -- end,
}

function M.update_capabilities()
  local opts = M
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local has_compl, compl = pcall(require, "lsp_compl")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    has_compl and compl.capabilities() or {},
    opts.capabilities or {}
  )
  assert(capabilities ~= nil)
  -- https://github.com/neovim/neovim/issues/23291
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
  return capabilities
end

M.setup_lsp_config = function(server)
  local server_opts = M.servers[server] or {}
  local capabilities = M.update_capabilities()

  server_opts["capabilities"] =
    vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
  if M.setup[server] then
    if M.setup[server](server, server_opts) then
      return
    end
  elseif M.setup["*"] then
    if M.setup["*"](server, server_opts) then
      return
    end
  end
  require("lspconfig")[server].setup(server_opts)
end

M.setup_configured = function()
  for server, server_opts in pairs(M.servers) do
    if server_opts then
      M.setup_lsp_config(server)
    end
  end
end

return M
