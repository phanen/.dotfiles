-- https://github.com/ibhagwan/smartyank.nvim
-- since there's no way to hook yank action(e.g. TextYankPre), "_d is always needed
-- usually "_d or usually d ???
au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
    -- require('vim.ui.clipboard.osc52').copy('+')({ vim.fn.getreg('"') })
    -- require('vim.ui.clipboard.osc52').copy('*')
  end,
})

-- https://github.com/jeffkreeftmeijer/vim-numbertoggle
au({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  command = [[if &nu && mode() != 'i' | set rnu | endif]],
})

au({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  command = [[if &nu | set nornu | endif]],
})

-- restore cursor position
au({ 'BufReadPost' }, { command = [[silent! normal! g`"zv']] })

-- create directories when needed, when saving a file
au('BufWritePre', {
  callback = function(ev)
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = (backup:gsub('[/\\]', '%%'))
    vim.go.backupext = backup
  end,
})

-- reload buffer
au({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then vim.cmd.checktime() end
  end,
})

au('VimResized', {
  group = ag('lazy_nvim_hook', { clear = true }),
  callback = function()
    if vim.o.columns < 100 then
      -- if openned
      -- vim.cmd.NvimTreeClose()
      -- vim.cmd.AerialClose()
      vim.cmd.wincmd('|')
    else
      vim.cmd.wincmd('=')
    end
  end,
})

au('User', {
  pattern = { 'LazyInstall*', 'LazyUpdate*', 'LazySync*', 'LazyRestore*' },
  group = ag('lazy_nvim_hook', { clear = true }),
  callback = function(...)
    require('lib.lazy').lazy_patch_callback(...)
    require('lib.lazy').lazy_cache_docs()
  end,
})

au('LspAttach', {
  group = ag('lsp_attach', { clear = true }),
  callback = function(ev)
    -- vim.lsp.inlay_hint.enable()

    local bn = function(lhs, rhs) map('n', lhs, rhs, { buffer = ev.buf }) end
    bn('gD', vim.lsp.buf.declaration)
    bn('gI', vim.lsp.buf.implementation)
    bn('gs', vim.lsp.buf.signature_help)
    bn('_', vim.lsp.buf.hover)
    bn('<leader>rn', vim.lsp.buf.rename)
  end,
})

-- local stack = {}
-- au('CmdlineEnter', {
--   once = true,
--   callback = function()
--     map('c', ' ', function() return ' ' end, { expr = true })
--     -- cmape('')
--   end,
-- })
--
-- au('CmdlineChanged', {
--   callback = function(ev) vim.print(ev, vim.fn.getcmdline()) end,
-- })
