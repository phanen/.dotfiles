local nvt = package.loaded['nvim-tree.api']
nvt.config.mappings.default_on_attach(0)

local node_path_dir = function()
  local node = nvt.tree.get_node_under_cursor()
  if not node then return end
  if node.parent and node.type == 'file' then return node.parent.absolute_path end
  return node.absolute_path
end

local n = map[0].n
n['h'] = nvt.node.navigate.parent
n['l'] = nvt.node.open.edit
n['o'] = nvt.tree.change_root_to_node
n['H'] = u.dirstack.prev
n['L'] = u.dirstack.next
n['<c-e>'] = function() u.pick.files { cwd = node_path_dir() or uv.cwd() } end
n['<c-f>'] = function() u.pick.lgrep { cwd = node_path_dir() or uv.cwd() } end
n['gj'], n['gk'] = u.repmv.pair_wrap(nvt.node.navigate.git.next, nvt.node.navigate.git.prev)
