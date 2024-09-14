local specs = {
  -- syntax
  { 'HiPhish/info.vim', cmd = 'Info' },
  { 'fladson/vim-kitty', ft = 'kitty' },
  { 'chrisbra/csv.vim', ft = 'csv' },
  { 'kmonad/kmonad-vim', ft = 'kbd' },
  { 'baskerville/vim-sxhkdrc', event = 'BufReadPre sxhkdrc' },
  { 'NoahTheDuke/vim-just', ft = 'just' },
  { 'Fymyte/rasi.vim', ft = 'rasi' },

  -- text process
  { 'hotoo/pangu.vim', cmd = 'Pangu', ft = 'markdown' },
  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  { 'HakonHarnes/img-clip.nvim', cmd = 'PasteImage', opts = {} },

  -- tex
  {
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
  },
}

return g.is_local and specs or {}
