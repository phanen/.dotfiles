-- TODO: ideally, it should be reloadable...

-- vscode-neovim
if g.vscode then
  require('mod.vscode')
  return fn['mod#vscode#setup']()
end

require 'mod.fastmove'
require 'mod.insert'
require 'mod.idl'
require 'mod.fmt'
require 'mod.msg'

-- input method
au('ModeChanged', {
  once = true,
  pattern = '*:[ictRss\x13]*',
  group = ag('IMSetup', { clear = true }),
  callback = function() require('mod.im').setup() end,
})

-- readline and others
-- FIXME: should trigger only once (other than once for each event)
au({
  'CmdlineEnter',
  'InsertEnter',
}, {
  once = true,
  group = ag('InsertMappings', { clear = true }),
  callback = function()
    if vim.g.loaded_insertmappings then return end
    vim.g.loaded_insertmappings = true
    -- vim.print('loaded insertmappings')
    -- FIXME: order matter, do not override cmp
    require('mod.insert').setup()
  end,
})

-- lsp-diags
au({
  'LspAttach',
  'DiagnosticChanged',
}, {
  once = true,
  desc = 'Apply lsp and diagnostic settings',
  group = ag('LspDiagnosticSetup', { clear = true }),
  callback = function()
    -- require('mod.lsp-diags').setup()
  end,
})

au({ 'BufWritePost', 'BufWinEnter' }, {
  once = true,
  -- nested = true,
  group = ag('StatusColumn', { clear = true }),
  desc = 'Init statuscolumn plugin',
  callback = function()
    -- require('mod.stc').setup()
  end,
})

-- statusline
-- TODO: opt_global? go o?
vim.o.statusline = [[%!v:lua.require'mod.stl'.get()]]

-- term
au('TermOpen', {
  group = ag('TermSetup', {}),
  callback = function(ev) require('mod.term').setup(ev.buf) end,
})

if g.vendor_bar then
  au({
    'BufReadPost',
    'BufWritePost',
    'BufNewFile',
    'BufEnter',
  }, {
    once = true,
    -- nested = true, -- ???
    group = ag('WinBarSetup', { clear = true }),
    callback = function()
      if vim.g.loaded_winbar then return end
      vim.g.loaded_winbar = true
      local winbar = require('mod.winbar')
      winbar.setup()
    end,
  })
end
