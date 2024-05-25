return {
  'kawre/leetcode.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cond = fn.argv()[1] == 'leetcode.nvim',
  lazy = false,
  keys = {
    { '<localleader>a', '<cmd>Leet lang<cr>' },
    { '<localleader>c', '<cmd>Leet console<cr>' },
    { '<localleader>d', '<cmd>Leet desc<cr>' },
    { '<localleader>i', '<cmd>Leet info<cr>' },
    { '<localleader>l', '<cmd>Leet list<cr>' },
    { '<localleader>r', '<cmd>Leet run<cr>' },
    { '<localleader>s', '<cmd>Leet submit<cr>' },
    { '<localleader>t', '<cmd>Leet tabs<cr>' },
    { '<localleader>y', '<cmd>Leet yank<cr>' },
    {
      '<localleader>o',
      function()
        vim.ui.open('https://leetcode.cn/problems/' .. fn.expand('%:t:r'):gsub('%d+%.', '', 1) .. '/solutions/')
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
}
