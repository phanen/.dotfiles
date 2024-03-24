local group = vim.api.nvim_create_augroup('Conf', { clear = true })

local au = function(ev, opts)
  opts = opts or {}
  opts.group = opts.group or group
  vim.api.nvim_create_autocmd(ev, opts)
end

-- smart yank
au('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
    -- if vim.fn.has('clipboard') ~= 1 then
    --   return
    -- end
    -- if vim.v.operator ~= 'y' then
    --   return
    -- end
    -- local ok, text = pcall(vim.fn.getreg, '0')
    -- if not ok or #text == 0 then
    --   return
    -- end
    -- ok, text = pcall(vim.fn.setreg, '+', text)
    -- if not ok then
    --   return
    -- end
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
  callback = function(ev)
    if vim.fn.bufname() == 'nofile' then
      map('n', 'q', '<cmd>q<cr>', { buffer = ev.buf })
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
au({ 'FocusGained', 'BufEnter' }, {
  callback = function()
    if vim.fn.getcmdwintype() == '' then
      vim.cmd 'checktime'
    end
  end,
})

au('Filetype', {
  pattern = { 'toggleterm', 'help', 'man' },
  callback = function(ev)
    if vim.bo.bt ~= '' then
      map('n', 'u', '<c-u>', { buffer = ev.buf })
      map('n', 'd', '<c-d>', { buffer = ev.buf })
    end
  end,
})

au('Filetype', {
  pattern = { 'NvimTree', 'help', 'man', 'aerial', 'fugitive*' },
  callback = function(ev)
    if vim.bo.bt ~= '' then
      map('n', 'q', '<cmd>q<cr>', { buffer = ev.buf })
    end
  end,
})

au('LspAttach', {
  callback = function(ev)
    local bn = function(lhs, rhs)
      map('n', lhs, rhs, { buffer = ev.buf })
    end
    bn('gD', vim.lsp.buf.declaration)
    bn('gI', vim.lsp.buf.implementation)
    bn('gs', vim.lsp.buf.signature_help)
    bn('<leader>i', vim.lsp.buf.hover)
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

-- au('SourceCmd', {
--   pattern = "*.lua",
--   callback = function(_)
--     vim.print('sourcing', vim.fn.expand('<afile>'))
--   end,
-- })

vim.api.nvim_create_autocmd('ModeChanged', {
  once = true,
  pattern = '*:[ictRss\x13]*',
  group = vim.api.nvim_create_augroup('IMSetup', {}),
  callback = function() end,
})
