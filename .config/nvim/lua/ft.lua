au('Filetype', {
  pattern = 'qf',
  callback = function()
    n('dd', '<cmd>lua require("lib.qf").qf_delete()<cr>', { buffer = true })
    x('d', '<cmd>lua require("lib.qf").qf_delete()<cr>', { buffer = true })
  end,
})

au('Filetype', {
  pattern = { 'help', 'man' },
  callback = function(ev)
    if vim.bo.bt ~= '' then
      map('n', 'u', '<c-u>', { buffer = ev.buf })
      map('n', 'd', '<c-d>', { buffer = ev.buf })
    end
  end,
})

au('Filetype', {
  pattern = { 'toggleterm' },
  callback = function(ev)
    -- make % usable
    vim.cmd [[se ft=bash]]
    -- workaround, mis touch
    map('n', '<c-o>', '<nop>', { buffer = ev.buf })
    map('n', '<c-i>', '<nop>', { buffer = ev.buf })

    -- workaround, insert at bottom not work
    map('n', 'i', 'A', { buffer = ev.buf })
  end,
})

au('Filetype', {
  pattern = { 'man' },
  callback = function(ev)
    -- TODO: BufRead trigger man plugin (set buf)
    vim.bo[ev.buf].bufhidden = 'hide'
    vim.bo[ev.buf].buftype = ''
  end,
})

-- fish_indent
au('Filetype', {
  pattern = { 'fish' },
  callback = function(ev)
    local nr = ev.buf
    vim.bo[nr].shiftwidth = 4
    vim.bo[nr].tabstop = 4
    vim.bo[nr].softtabstop = 4
    vim.bo[nr].expandtab = true
  end,
})

-- anyway, we should not
au('Filetype', {
  pattern = { 'go' },
  callback = function(ev)
    local nr = ev.buf
    vim.bo[nr].expandtab = false
  end,
})

au('Filetype', {
  pattern = { 'lua', 'vim' },
  callback = function()
    -- TODO: for lua(non-vim?), default 'K' is manual
    -- n('K', '<cmd>HelpTags<cr>')
  end,
})

-- jupytext
au('BufReadCmd', {
  once = true,
  pattern = '*.ipynb',
  group = ag('JupyTextSetup', {}),
  callback = function(ev)
    require('mod.jupytext').setup(ev.buf)
    return true
  end,
})

au('Filetype', {
  pattern = { 'markdown', 'typst' },
  group = ag('MarkUp', { clear = true }),
  callback = function(ev)
    nx('<c- >', r('mder.line').toggle_lines, { buffer = ev.buf })
    x('<c-e>', r('mder.codeblock').surround, { buffer = ev.buf })
    n('o', r('mder.autolist').listdn, { buffer = ev.buf })
    n('O', r('mder.autolist').listup, { buffer = ev.buf })

    local ox = function(...) map({ 'o', 'x' }, ...) end
    -- PERF(error-handler): hard to find debug...
    -- nx('i<c-e>', nil, { buffer = ev.buf })
    ox('i<c-e>', r('lib.textobj').codeblock_i, { buffer = ev.buf })
    ox('a<c-e>', r('lib.textobj').codeblock_i, { buffer = ev.buf })
  end,
})

au('Filetype', {
  pattern = 'gitcommit',
  callback = function() vim.cmd.startinsert() end,
})
