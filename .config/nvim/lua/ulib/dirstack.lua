local Dirstack = {}

-- another problem: some DirChanged is ignored when nested in event (e.g. nvim-tree)
-- so patches may be needed

local log = vim.notify

---@type HashList
local hlist

---@type HashNode
local curr -- minify context

local noau = false
local chdir_noau = function(dir)
  noau = true
  fn.chdir(dir)
  log(dir)
  noau = false
end

-- insert node after current one, discard subsequent nodes
-- dir should be expanded
-- before: head -> ... -> x -> ... -> tail
--                      (curr)
-- after:  head -> ... -> x -> node -> tail
--                            (curr)
local on_dirchange = function(dir)
  if dir == curr.key then return end
  local node = hlist.hash[dir]
  node = node and hlist:delete(node) or { key = dir }
  hlist:delete_all_after(curr)
  hlist:insert_after(curr, node)
  curr = node
end

Dirstack.reset_hlist = function()
  local dir = assert(uv.cwd())
  hlist = u.hashlist {}
  curr = { key = dir } ---@type HashNode
  hlist:insert_after(hlist.head, curr)
end

Dirstack.setup = function()
  if g.setuped_dirstack then return end
  g.setuped_dirstack = true
  Dirstack.reset_hlist()
  u.aug.dirstack = {
    'Dirchanged',
    function(ev)
      if noau or ev.file == '' then return end
      on_dirchange(ev.file)
    end,
  }
end

---maybe unsafe
local build = function(next)
  Dirstack.setup()
  local nav = {
    stop = next == 'prev' and hlist.head or hlist.tail,
    next = next,
  }
  local function goto_next_clean(redo)
    local node = assert(curr[nav.next])
    if node == nav.stop then --
      return log(('no %s'):format(nav.next))
    end
    local dir = assert(node.key)
    if not uv.fs_stat(dir) then
      redo = redo and redo + 1 or 1
      log(('dir [%s] deleted, redo [%s]'):format(dir, redo))
      curr[nav.next] = node[nav.next]
      hlist:delete(node)
      return goto_next_clean(redo)
    end
    curr = node
    return chdir_noau(dir)
  end
  return goto_next_clean
end

Dirstack.prev = build 'prev'
Dirstack.next = build 'next'

Dirstack.hist = function()
  local msg = {}
  hlist:foreach(function(node)
    local bar = node == curr and '> ' or '  '
    msg[#msg + 1] = ('%s%s'):format(bar, node.key)
  end)
  log(table.concat(msg, '\n'))
end

Dirstack.fuzzy = function()
  Dirstack.setup()
  local ok, _ = pcall(require, 'fzf-lua')
  local fzf_fuzzy = function()
    require('fzf-lua').fzf_exec(function(fzf_cb)
      coroutine.wrap(function()
        local co = coroutine.running()
        hlist:foreach(function(node)
          local dir = node.key
          fzf_cb(dir, function() coroutine.resume(co) end)
          coroutine.yield()
        end)
        fzf_cb(nil)
      end)()
    end, {
      preview = 'eza --color=always -l {}',
      actions = { ['enter'] = function(sel) fn.chdir(sel[1]) end },
    })
  end
  local ui_select = function()
    local items = {}
    hlist:foreach(function(node) items[#items + 1] = node.key end)
    vim.ui.select(items, { prompt = 'Dirstack: ' }, function(x) fn.chdir(assert(x)) end)
  end
  Dirstack.fuzzy = ok and fzf_fuzzy or ui_select
  Dirstack.fuzzy()
end

return Dirstack
