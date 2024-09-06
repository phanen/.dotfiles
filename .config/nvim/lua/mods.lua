return {
  {
    dir = 'mod/insert',
    main = 'mod.insert',
    event = { 'CmdlineEnter', 'InsertEnter' },
    opts = {},
  },
  {
    dir = 'mod/im',
    main = 'mod.im',
    event = { 'ModeChanged *:[ictRss\x13]*' },
    opts = {},
  },
  {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    -- { 'BufReadPost', 'BufWritePost', 'BufNewFile', 'BufEnter', }
    dependencies = { -- fzf support
      -- 'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require('dropbar').setup {
        general = {
          enable = function(buf, win, info)
            if vim.bo[buf].ft == 'fugitiveblame' then return true end
            return fn.win_gettype(win) == ''
              and vim.wo[win].winbar == ''
              and vim.bo[buf].bt == ''
              and u.has_ts(buf)
          end,
        },
      }
    end,
  },
  -- 'LspAttach',
  -- 'DiagnosticChanged',
  {
    dir = 'mod/stc',
    main = 'mod.stc',
    cond = false,
    event = {
      'BufWritePost',
      'BufWinEnter',
    },
    opts = {},
  },
  {
    dir = 'mod/term',
    main = 'mod.term',
    cond = false,
    event = 'TermOpen',
    opts = {},
  },
  {
    dir = 'mod/jupytext',
    main = 'mod.jupytext',
    event = 'BufReadCmd *.ipynb',
  },
  {
    'phanen/dirstack.nvim',
    event = 'DirchangedPre',
    keys = {
      { ' <c-p>', "<cmd>lua require('dirstack').prev()<cr>" },
      { ' <c-n>', "<cmd>lua require('dirstack').next()<cr>" },
      { ' <c-l>', "<cmd>lua require('dirstack').hist()<cr>" },
    },
    opts = {},
  },
  { 'phanen/readline.nvim', branch = 'fix-dir-structure' },
  { 'phanen/mder.nvim', ft = 'markdown' },

  {
    dir = 'mod/vt',
    main = 'mod.vt',
    keys = { { ' <c-b>', function() require('mod.vt').convert() end } },
  },
}
