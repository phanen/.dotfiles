return {
  {
    'kawre/leetcode.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cond = fn.argv()[1] == 'leetcode.nvim',
    lazy = false,
    keys = {
      { '+a', '<cmd>Leet lang<cr>' },
      { '+c', '<cmd>Leet console<cr>' },
      { '+d', '<cmd>Leet desc<cr>' },
      { '+i', '<cmd>Leet info<cr>' },
      { '+l', '<cmd>Leet list<cr>' },
      { '+r', '<cmd>Leet run<cr>' },
      { '+s', '<cmd>Leet submit<cr>' },
      { '+t', '<cmd>Leet tabs<cr>' },
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
