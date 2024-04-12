return {
  {
    'kwkarlwang/bufjump.nvim',
    keys = {
      { '<leader><c-o>', "<cmd>lua require('bufjump').backward()<cr>" },
      { '<leader><c-i>', "<cmd>lua require('bufjump').forward()<cr>" },
    },
  },
  {
    'phanen/dirstack.nvim',
    event = 'DirchangedPre',
    keys = {
      { '<leader><c-p>', "<cmd>lua require('dirstack').prev()<cr>" },
      { '<leader><c-n>', "<cmd>lua require('dirstack').next()<cr>" },
      { '<leader><c-l>', "<cmd>lua require('dirstack').hist()<cr>" },
    },
    opts = {},
  },
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        should_preview_cb = function(bufnr, _)
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if bufname:match '^fugitive://' then return false end
          if fsize > 100 * 1024 then return false end
          return true
        end,
      },
    },
  },
  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      { 'n', [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]] },
      { 'N', [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]] },
      { '*', [[*<cmd>lua require('hlslens').start()<cr>]], { remap = true } },
      { '#', [[#<cmd>lua require('hlslens').start()<cr>]] },
      { 'g*', [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { 'g#', [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        '<esc>',
        function()
          vim.cmd.noh()
          require('hlslens').stop()
          vim.api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
}
