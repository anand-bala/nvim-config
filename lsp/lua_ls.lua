return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },

  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".jj",
    ".git",
  },
  -- Note this is ignored if the project has a .luarc.json
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        globals = {
          "vim",
          "require",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.list_extend(
          { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
          vim.api.nvim_get_runtime_file("lua/", true)
        ),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  --- @param client vim.lsp.Client
  --- @param bufnr integer
  on_attach = function(client, bufnr)
    -- Copied from lewis6991's config
    local api = vim.api

    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        vim.uv.fs_stat(path .. "/.luarc.json")
        or vim.uv.fs_stat(path .. "/.luarc.jsonc")
      then
        -- Updates to settings are ingored if a .luarc.json is present
        return
      end
    end

    client.settings = vim.tbl_deep_extend("keep", client.settings, {
      Lua = { workspace = { library = {} } },
    })

    --- @param x string
    --- @return string?
    local function match_require(x)
      return x:match "require"
        and (
          x:match "require%s*%(%s*'([^.']+).*'%)"
          or x:match 'require%s*%(%s*"([^."]+).*"%)'
          or x:match "require%s*'([^.']+).*'%)"
          or x:match 'require%s*"([^."]+).*"%)'
        )
    end

    --- @param first? integer
    --- @param last? integer
    local function on_lines(first, last)
      local do_change = false

      local lines = api.nvim_buf_get_lines(bufnr, first or 0, last or -1, false)
      for _, line in ipairs(lines) do
        local m = match_require(line)
        if m then
          for _, mod in ipairs(vim.loader.find(m, { patterns = { "", ".lua" } })) do
            local lib = vim.fs.dirname(mod.modpath)
            local libs = client.settings.Lua.workspace.library
            if not vim.tbl_contains(libs, lib) then
              libs[#libs + 1] = lib
              do_change = true
            end
          end
        end
      end

      if do_change then
        client:notify(
          "workspace/didChangeConfiguration",
          { settings = client.settings }
        )
      end
    end

    api.nvim_buf_attach(bufnr, false, {
      on_lines = function(_, _, _, first, _, last)
        on_lines(first, last)
      end,
      on_reload = function()
        on_lines()
      end,
    })

    -- Initial scan
    on_lines()
  end,
}