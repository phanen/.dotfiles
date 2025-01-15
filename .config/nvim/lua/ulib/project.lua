---@class project.opts
---fzf ignore globs, support negative pattern (e.g. !test) https://github.com/ibhagwan/fzf-lua/discussions/1210
---@field iglobs? string[]
---project-local ft opts for conform
---@field conform_ft_opts? table<string, string[]>
local Project

---@type table<string, project.opts?>
local mod

---@param field string project field
---@param root? string|fun():string rooter
local get = function(field, root)
  if not uv.fs_stat(g.rc_path) then return end
  mod = mod and mod or g.rc_path and loadfile(g.rc_path)()
  root = root and u.eval(root) or fs.root(0, '.git') -- a trivial fallback rooter
  local name = root and fs.basename(fn.expand(root))
  -- https://github.com/neovim/neovim/pull/32218
  return mod and name and field and vim.tbl_get(mod, name, field)
end

---getter of project-local config
Project = setmetatable({}, {
  __index = function(_, field) return get(field) end,
  __call = function(_, root)
    return setmetatable({}, {
      __index = function(_, field) return get(field, root) end,
    })
  end,
})

return Project
