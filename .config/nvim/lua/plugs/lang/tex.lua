return {
  'lervag/vimtex',
  -- lazy = false, -- :h :VimtexInverseSearch
  ft = 'tex',
  cmd = { 'VimtexCompile', 'VimtexClean', 'VimtexCompileSS' },
  config = function()
    vim.g.vimtex_view_method = 'sioyek'
    vim.g.tex_flavor = 'xelatex'
    vim.g.tex_conceal = 'abdmgs'
    vim.g.vimtex_quickfix_mode = 0
  end,
}
