au('Filetype', {
  pattern = 'qf',
  callback = function()
    map('n', 'dd', '<cmd>lua require("lib.qf").qf_delete()<cr>', { buffer = true })
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

-- fish_indent
au('Filetype', {
  pattern = { 'fish' },
  callback = function(args)
    local buf = args.buf
    vim.bo[args.buf].shiftwidth = 4
    vim.bo[args.buf].tabstop = 4
    vim.bo[args.buf].softtabstop = 4
    vim.bo[args.buf].expandtab = true
  end,
})
