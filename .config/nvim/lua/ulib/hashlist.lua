---@alias HashKey string|number or has __tostring...

---@class HashNode
---@field prev HashNode?
---@field next HashNode?
---@field key HashKey
---@field data any

---@class HashList
---@field hash table<HashKey, HashNode>
---@field head HashNode
---@field tail HashNode
---@field size integer
local Hashlist = {}

Hashlist.__index = Hashlist

---@return HashList
--- lsp support for __call: https://github.com/LuaLS/lua-language-server/issues/95
Hashlist.__call = function(cls, hash)
  assert(hash, 'must provide a hash table')
  local obj = { hash = hash, head = {}, tail = {}, size = 0 }
  obj.head.next = obj.tail
  obj.tail.prev = obj.head
  return setmetatable(obj, cls)
end

setmetatable(Hashlist, Hashlist)

---@param node HashNode
---@return HashNode
function Hashlist:delete(node)
  assert(node ~= self.head and node ~= self.tail)
  self.hash[node.key] = nil
  node.prev.next = node.next
  node.next.prev = node.prev
  self.size = self.size - 1
  return node
end

---@param node HashNode
---@param delete_cb? fun(node: HashNode)
function Hashlist:delete_all_after(node, delete_cb)
  local to_delete = assert(node.next)
  if to_delete == self.tail then return node end
  if delete_cb and vim.is_callable(delete_cb) then
    repeat
      self.hash[to_delete.key] = nil
      delete_cb(to_delete)
      self.size = self.size - 1
      to_delete = to_delete.next
    until to_delete == self.tail
  else
    repeat
      self.hash[to_delete.key] = nil
      self.size = self.size - 1
      to_delete = to_delete.next
    until to_delete == self.tail
  end
  node.next = self.tail
  self.tail.prev = node
end

---@param node HashNode
---@param inserted HashNode
function Hashlist:insert_after(node, inserted)
  inserted.next = node.next
  node.next.prev = inserted
  inserted.prev = node
  node.next = inserted
  self.hash[inserted.key] = inserted
  self.size = self.size + 1
end

---@param callback fun(node: HashNode):boolean?
function Hashlist:foreach(callback)
  local node = self.head.next
  while node and node ~= self.tail do
    if callback(node) == true then return end
    node = node.next
  end
end

---@param callback fun(node: HashNode):boolean?
function Hashlist:foreach_r(callback)
  local node = self.tail.prev
  while node and node ~= self.head do
    if callback(node) == true then return end
    node = node.prev
  end
end

---@param key HashKey
function Hashlist:access(key)
  local node = self.hash[key]
  node = node and self:delete(node) or { key = key }
  self:insert_after(self.head, node)
end

return Hashlist
