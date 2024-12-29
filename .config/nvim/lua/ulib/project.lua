local Project = {}

---get project local config
---@param ctx table
Project.get = function(name, ctx)
  if not uv.fs_stat(g.local_path) then return {} end
  local conf = g.local_path and loadfile(g.local_path)() or {}
  local cwd = ctx.cwd or uv.cwd()
  if not cwd then return {} end
  local root = u.git.root { cwd = fs.normalize(cwd) }
  return root and vim.tbl_get(conf, root, name)
end

return Project
