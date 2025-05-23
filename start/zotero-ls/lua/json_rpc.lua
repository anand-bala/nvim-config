---@brief JSON-RPC Library

---@class RpcHandle
---@field url string
local RpcHandle = {}
local rpc_meta = { __index = RpcHandle }

---@param url string
RpcHandle.new = function(url)
  vim.validate("url", url, "string")
  return setmetatable({ url = url }, rpc_meta)
end

---@param

---@class JsonRpcRequest
---@field method string
---@field params? table
---@field id? string|integer

---@class JsonRpcResponse
---@field id? string|integer
---@field error? {code: integer, message: string}
---@field result? any
