local n = map.n[0]
local x = map.x[0]

-- check nvim's lsp preset `:h lsp-config`
-- * tagfunc <c-]>
-- * omnifunc c-x c-o, buggy, no idea if there's really someone use omnifunc
-- * formatexpr gq
-- * https://github.com/neovim/neovim//blob/6ad025ac88f968dbeaea05e95cf40d64782793e0/runtime/lua/vim/lsp.lua#L330
-- * https://github.com/neovim/neovim//blob/6ad025ac88f968dbeaea05e95cf40d64782793e0/src/nvim/insexpand.c#L1103
local lsp_keymap = function(ev)
  -- lsp.inlay_hint.enable()
  -- TODO: set a short query timeout...
  ---@diagnostic disable-next-line: redefined-local
  -- n('<c-h>', lsp.buf.signature_help)
  n('_', lsp.buf.hover)
  n(' rn', lsp.buf.rename)
  n(
    ' <c-r>',
    function() return ':IncRename ' .. fn.expand('<cword>') end,
    { expr = true, replace_keycodes = true }
  )
end

local quit_filetypes = setmetatable({
  aerial = true,
  floggraph = true,
  gitcommit = true,
  ['gitsigns-blame'] = true,
  git = true,
  help = true,
  info = true,
  man = true,
  NvimTree = true,
  qf = true,
}, {
  __index = function(m, k)
    if k:match('fugitive*') then
      rawset(m, k, true)
      return true
    end
  end,
})

local ts_keymap = function()
  local ts_is = require('nvim-treesitter.incremental_selection')
  n('<cr>', ts_is.init_selection)
  x('<cr>', ts_is.node_incremental)
  x('<s-cr>', ts_is.node_decremental)
  x('<s-tab>', ts_is.scope_incremental)
end

local ft_keymap = function(ev)
  if vim.bo.bt ~= '' and not vim.bo.ma then
    n('u', '<c-u>')
    n.nowait('d', '<c-d>')
  end
  if quit_filetypes[vim.bo.ft] then
    -- TODO: vim.wo.winfixbuf = true
    n('q', 'ZZ')
  end

  if u.has_ts(0) then ts_keymap() end
  local buf = ev.buf
  -- local wins = fn.win_findbuf(buf)
  -- vim.b.gitsigns_preview
  -- vim.w
end

augroup(
  'BufKeymap',
  { 'LspAttach', { callback = lsp_keymap } },
  { 'Filetype', { callback = ft_keymap } }
)
