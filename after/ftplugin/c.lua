---If there is a build.ninja in the project, the directory containing it
---@type string|nil directory with build.ninja or nil
local build_ninja_dir = (function()
  local function check(path)
    return (vim.uv.fs_stat(vim.fs.joinpath(path, "build.ninja")) or { type = nil }).type == "file"
  end

  local cwd = vim.fn.getcwd()
  if check(cwd) then return cwd end

  -- else check in the build directory
  local build_dir = vim.fs.normalize(vim.fs.joinpath(cwd, "build"))
  if check(build_dir) then return build_dir end
  -- else, recurse in the build directory
  for name, kind in
    vim.fs.dir(build_dir, {
      depth = 2,
    })
  do
    local path = vim.fs.joinpath(build_dir, name)
    if kind == "directory" and check(path) then return path end
  end
end)()

if build_ninja_dir ~= nil then
  vim.g.ninja_makeprg_builddir = build_ninja_dir
  vim.cmd [[:compiler ninja]]
end
