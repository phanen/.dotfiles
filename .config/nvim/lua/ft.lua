au('Filetype', {
  pattern = 'qf',
  callback = function()
    map('n', 'dd', '<cmd>lua require("lib.qf").qf_delete()<cr>', { buffer = true })
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
    local buf = ev.buf
    vim.bo[ev.buf].shiftwidth = 4
    vim.bo[ev.buf].tabstop = 4
    vim.bo[ev.buf].softtabstop = 4
    vim.bo[ev.buf].expandtab = true
  end,
})
