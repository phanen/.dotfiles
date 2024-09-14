g.gitsigns_signs = {
  add = { text = '' },
  change = { text = '' },
  delete = { text = '' },
  topdelete = { text = '‾' },
  changedelete = { text = '' }, -- hl-delete
  untracked = { text = '' }, -- hl-add
}

return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  cmd = 'Gitsigns',
  opts = {
    max_file_length = 20000,
    attach_to_untracked = true, -- used in diff mode
    preview_config = { border = g.border },
    signs = g.gitsigns_signs,
    signs_staged = g.gitsigns_signs,
  },
}
