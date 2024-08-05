local n = map.n

-- tabpages
local tabswitch = function(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = fn.tabpagenr('$')
    if count <= num_tabs then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end

n('gt', tabswitch(vim.cmd.tabnext))
n('gT', tabswitch(vim.cmd.tabprev))

-- TODO: don't create annoying raw buffer
n(' 0', '<cmd>0tabnew<cr>')
for i = 1, 9 do
  n(' ' .. tostring(i), tabswitch(vim.cmd.tabnext, i))
  n('+' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<cr>')
end
