local M = {}

function M.mux(cond, lhs, rhs) return (cond and { lhs } or { rhs })[1] end

---@param path string
---@return table<string, fun(...): any>
M.reqcall = function(path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...) return require(path)[k](...) end
    end,
  })
end

---@return string
M.get_root = function()
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
  ---@type string[]
  local roots = {}
  if path ~= "" then
    for _, client in pairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws) return vim.uri_to_fname(ws.uri) end, workspace)
        or client.config.root_dir and { client.config.root_dir }
        or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then roots[#roots + 1] = r end
      end
    end
  end
  ---@type string?
  local root = roots[1]
  if not root then
    path = path == "" and vim.loop.cwd() or vim.fs.dirname(path)
    ---@type string?
    root = vim.fs.find({ ".git" }, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

---@generic T:table
---@param callback fun(itme: T, key: any)
---@param list [TODO:parameter]
M.foreach = function(callback, list)
  for k, v in pairs(list) do
    callback(v, k)
  end
end

-- https://vi.stackexchange.com/questions/467/how-can-i-clear-a-register-multiple-registers-completely
--- get visual text string
---@return string
M.get_visual = function()
  local reg_bak = vim.fn.getreg "v"
  vim.fn.setreg("v", {})
  -- do nothing in normal mode
  vim.cmd [[noau normal! "vy\<esc\>]]
  local sel_text = vim.fn.getreg "v"
  vim.fn.setreg("v", reg_bak)
  return sel_text
end

return M
