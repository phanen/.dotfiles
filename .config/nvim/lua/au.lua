-- smart yank
au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
    -- if vim.fn.has('clipboard') ~= 1 then
    --   return
    -- end
    --   if vim.v.operator ~= 'y' then
    --     return
    --   end
    --   local ok, text = pcall(vim.fn.getreg, '0')
    --   if not ok or #text == 0 then
    --     return
    --   end
    --   ok, text = pcall(vim.fn.setreg, '+', text)
    --   if not ok then
    --     return
    --   end
  end,
})

-- credit to https://github.com/jeffkreeftmeijer/vim-numbertoggle
au({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  command = [[if &nu && mode() != 'i' | set rnu | endif]],
})
au({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  command = [[if &nu | set nornu | endif]],
})

-- restore cursor position
au({ 'BufReadPost' }, {
  callback = function()
    vim.api.nvim_exec2('silent! normal! g`"zv', { output = false })
  end,
})

-- https://www.reddit.com/r/neovim/comments/wjzjwe/how_to_set_no_name_buffer_to_scratch_buffer/
au({ 'BufLeave' }, {
  callback = function()
    if vim.fn.bufname() == '' and vim.fn.line '$' == 1 and vim.fn.getline(1) == '' then
      vim.bo.buftype = 'nofile'
      vim.bo.bufhidden = 'wipe'
    end
  end,
})

au({ 'BufEnter' }, {
  callback = function()
    if vim.fn.bufname() == 'nofile' then
      n('q', '<cmd>q<cr>', { buffer = true })
    end
  end,
})

-- create directories when needed, when saving a file
au('BufWritePre', {
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
    local backup = vim.fn.fnamemodify(file, ':p:~:h')
    backup = backup:gsub('[/\\]', '%%')
    vim.go.backupext = backup
  end,
})

-- reload buffer on focus
au({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

au('Filetype', {
  pattern = { 'toggleterm', 'help', 'man' },
  callback = function()
    if vim.bo.bt ~= '' then
      n('u', '<c-u>', { buffer = true })
      n('d', '<c-d>', { buffer = true })
    end
  end,
})

au('Filetype', {
  pattern = { 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
  callback = function()
    if vim.bo.bt ~= '' then
      n('q', '<cmd>q<cr>', { buffer = true })
    end
  end,
})

au('Filetype', {
  pattern = { 'help', 'man' },
  callback = function()
    if vim.bo.bt ~= '' then
      n('u', '<c-u>', { buffer = true })
      n('d', '<c-d>', { buffer = true })
    end
  end,
})

au('LspAttach', {
  callback = function(_)
    local bn = function(lhs, rhs)
      map('n', lhs, rhs, { buffer = 0 })
    end
    bn('gD', vim.lsp.buf.declaration)
    bn('gI', vim.lsp.buf.implementation)
    bn('gs', vim.lsp.buf.signature_help)
    bn('<leader>i', vim.lsp.buf.hover)
    bn('<leader>rn', vim.lsp.buf.rename)
  end,
})

-- au('SourceCmd', {
--   pattern = "*.lua",
--   callback = function(_)
--     vim.print('sourcing', vim.fn.expand('<afile>'))
--   end,
-- })
