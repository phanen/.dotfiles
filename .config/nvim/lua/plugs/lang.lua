local specs = {
  -- syntax
  { 'HiPhish/info.vim', cmd = 'Info' },
  { 'fladson/vim-kitty', ft = 'kitty' },
  -- text process
  { 'hotoo/pangu.vim', cmd = { 'Pangu', 'PanguEnable' } },
  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  { 'HakonHarnes/img-clip.nvim', cmd = 'PasteImage', opts = {} },
  { 'chaimleib/vim-renpy', ft = 'renpy' },
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

  {
    'kawre/leetcode.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cond = fn.argv()[1] == 'leetcode.nvim',
    lazy = false,
    keys = {
      { '+c', '<cmd>Leet console<cr>' },
      { '+k', '<cmd>Leet desc<cr>' },
      { '+i', '<cmd>Leet info<cr>' },
      { '+l', '<cmd>Leet list<cr>' },
      { '+r', '<cmd>Leet run<cr>' },
      { '+s', '<cmd>Leet submit<cr>' },
      { '+t', '<cmd>Leet test<cr>' },
      { '+y', '<cmd>Leet yank<cr>' },
      {
        '+o',
        function()
          vim.ui.open(
            'https://leetcode.cn/problems/'
              .. fn.expand('%:t:r'):gsub('%d+%.', '', 1)
              .. '/solutions/'
          )
        end,
      },
    },
    opts = {
      cn = { enabled = true },
      injector = {
        ['cpp'] = {
          before = { '#include <bits/stdc++.h>', '#include "lib.h"', 'using namespace std;' },
          after = 'int main() {}',
        },
      },
      storage = { home = '~/codes/leetcode' },
      image_support = false,
    },
  },
}

return g.is_local and specs or {}
