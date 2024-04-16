au('TextYankPost', {
  callback = function() vim.highlight.on_yank() end,
})

-- credit to https://github.com/jeffkreeftmeijer/vim-numbertoggle
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
  callback = function(args)
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = (backup:gsub('[/\\]', '%%'))
    vim.go.backupext = backup
  end,
})

-- reload buffer on focus
au({ 'FocusGained', 'BufEnter' }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then vim.cmd 'checktime' end
  end,
})

au('Filetype', {
  pattern = { 'toggleterm', 'help', 'man' },
  callback = function(args)
    if vim.bo.bt ~= '' then
      map('n', 'u', '<c-u>', { buffer = args.buf })
      map('n', 'd', '<c-d>', { buffer = args.buf })
    end
  end,
})

au('LspAttach', {
  callback = function(args)
    local bn = function(lhs, rhs) map('n', lhs, rhs, { buffer = args.buf }) end
    bn('gD', vim.lsp.buf.declaration)
    bn('gI', vim.lsp.buf.implementation)
    bn('gs', vim.lsp.buf.signature_help)
    bn('_', vim.lsp.buf.hover)
    bn('<leader>rn', vim.lsp.buf.rename)
  end,
})

au('VimResized', {
  callback = function()
    if vim.o.columns < 100 then
      vim.cmd.wincmd('|')
    else
      vim.cmd.wincmd('=')
    end
  end,
})

-- fish_indent
au('Filetype', {
  pattern = { 'fish' },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.expandtab = true
  end,
})

au('User', {
  pattern = { 'LazyInstall*', 'LazyUpdate*', 'LazySync*', 'LazyRestore*' },
  callback = function(...)
    require('util').lazy_patch(...)
    require('util').lazy_cache_docs()
  end,
})
