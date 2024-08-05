return {
  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      {
        'n',
        [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]],
      },
      {
        'N',
        [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]],
      },
      {
        '*',
        [[*<cmd>lua require('hlslens').start()<cr>]],
        { remap = true },
      },
      { '#', [[#<cmd>lua require('hlslens').start()<cr>]] },
      { 'g*', [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { 'g#', [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        '<esc>',
        function()
          vim.cmd.noh()
          require('hlslens').stop()
          api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
}
