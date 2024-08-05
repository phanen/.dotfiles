local n = map.n

-- win
n('<c-j>', '<cmd>wincmd w<cr>')
n('<c-k>', '<cmd>wincmd W<cr>')

-- TODO: make resize repeatable
n('<c-s>', function()
  api.nvim_feedkeys(vim.keycode '<c-w>', 'n', true)
  local char = fn.getcharstr()
  if char == 'k' then
  elseif char == 'j' then
  else
    api.nvim_feedkeys(char, 'n', true)
  end
  -- thiss work, but not trigger pending
  -- but use <c-g> trigger a pending
  -- if char ~= 'g' then return end
  -- weird
  -- api.nvim_feedkeys(fn.getcharstr(), 'n', true)
end, { expr = true })

-- smart shrink/expand
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
-- n('<c-s>gf', '<cmd>wincmd gf<cr>')
n(' k', '<cmd>NvimTreeFindFileToggle<cr>')
n(' q', u.qf.qf_toggle)
n('+q', u.util.force_close_tabpage)
n('q', u.smart.quit)
n(' wo', '<cmd>AerialToggle!<cr>')
-- n(' wo', '<cmd>Outline<cr>')
n(' wi', '<cmd>LspInfo<cr>')
n(' wl', '<cmd>Lazy<cr>')
n(' wm', '<cmd>Mason<cr>')
n(' wh', '<cmd>ConformInfo<cr>')

-- n(' Q', '<cmd>quitall!<cr>')
n(' Q', '<cmd>=os.exit()<cr>')
