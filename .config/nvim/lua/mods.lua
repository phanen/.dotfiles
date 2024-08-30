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
  -- e.g. useful in `require`
  -- {
  --   dir = 'mod/lua-gf',
  --   main = 'mod.lua-gf',
  --   ft = 'lua',
  -- },
  {
    dir = 'mod/winbar',
    cond = g.vendor_bar,
    event = {
      'BufReadPost',
      -- 'BufWritePost',
      'BufNewFile',
      -- 'BufEnter',
    },
    main = 'mod.winbar',
    keys = function()
      ---@module 'mod.winbar.api'
      local w = u.lazy_req('mod.winbar.api')
      return {
        { '+;', w.pick },
        { '[C', w.goto_context_start },
        { ']C', w.select_next_context },
      }
    end,
    opts = {},
  },
  {
    'Bekaboo/dropbar.nvim',
    cond = not g.vendor_bar,
    -- cond = fn.has('nvim-0.10') == 1,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { -- fzf support
      -- 'nvim-telescope/telescope-fzf-native.nvim',
    },
    opts = { general = { enable = require('mod.winbar.config').opts.enable } },
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
