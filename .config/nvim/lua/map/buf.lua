local n = map.n

n(']b', '<cmd>exec v:count1 . "bn"<cr>')
n('[b', '<cmd>exec v:count1 . "bp"<cr>')
n(']->', '<cmd>exec v:count1 . "bn"<cr>')
n('[->', '<cmd>exec v:count1 . "bp"<cr>')
n('<c-e>', '<cmd>BufferLineCyclePrev<cr>')
n('<c-f>', '<cmd>BufferLineCycleNext<cr>')
n('H', '<cmd>BufferLineMovePrev<cr>')
n('L', '<cmd>BufferLineMoveNext<cr>')
n(' bl', '<cmd>BufferLineCloseLeft<cr>')
n(' bo', '<cmd>BufferLineCloseOthers<cr>')
n(' br', '<cmd>BufferLineCloseRight<cr>')
n(' <c-o>', u.bufop.backward_buf)
n(' <c-i>', u.bufop.forward_buf)
n('<a-o>', u.bufop.backward_in_buf)
n('<a-i>', u.bufop.forward_in_buf)

n.nowait('<c-w>', u.bufop.delete) -- `nowait`: avoid deleting <c-w>d, <c-w><c-d> (neovim 0.10+)
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

-- win
n('<c-j>', '<cmd>wincmd w<cr>')
n('<c-k>', '<cmd>wincmd W<cr>')
n.expr('<c-s>', function()
  api.nvim_feedkeys(vim.keycode '<c-w>', 'n', true)
  local char = fn.getcharstr()
  if char == 'k' then
  elseif char == 'j' then
  else
    api.nvim_feedkeys(char, 'n', true)
  end
  -- TODO:
  -- these work, but not trigger pending
  -- but use <c-g> trigger a pending
  -- if char ~= 'g' then return end
  -- weird
  -- api.nvim_feedkeys(fn.getcharstr(), 'n', true)
end)

-- smart shrink/expand (TODO: make resize repeatable)
n('<c-s><', '<cmd>wincmd 10<<cr>')
n('<c-s>>', '<cmd>wincmd 10><cr>')
n('<c-s>+', '<cmd>resize +5<cr>')
n('<c-s>-', '<cmd>resize -5<cr>')

-- n('<c-s>g', function()
--   api.nvim_feedkeys(vim.keycode '<c-w><c-g>', 'n', true)
--   -- api.nvim_feedkeys(vim.keycode '<c-w>g', 'n', true)
--   -- api.nvim_feedkeys('g', 'n', true)
--   -- api.nvim_feedkeys(vim.keycode '<c-g><c-g>', 'n', true)
--   api.nvim_feedkeys(fn.getcharstr(), 'n', true)
-- end)

n('<c-s><c-s>', '<cmd>wincmd q<cr>')
n('<c-s>gf', '<cmd>wincmd gf<cr>')
n('<c-s>gd', '<cmd>wincmd gd<cr>')
n('+q', u.misc.force_close_tabpage)
n('q', u.misc.quit)
n(' Q', '<cmd>quitall!<cr>')
n(' Q', '<cmd>=os.exit()<cr>')
