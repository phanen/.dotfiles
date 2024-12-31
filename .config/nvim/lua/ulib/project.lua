local Project = {}

---get project local config
---@param ctx table?
Project.get = function(name, ctx)
  ctx = ctx or {}
  if not uv.fs_stat(g.rc_path) then return end
  local conf = g.rc_path and loadfile(g.rc_path)() or {}
  local cwd = ctx.cwd or uv.cwd()
  if not cwd then return {} end
  local root = u.git.root { cwd = fs.normalize(cwd) }
  return root and vim.tbl_get(conf, root, name)
end

return Project
