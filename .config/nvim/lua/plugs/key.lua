return {
  {
    'anuvyklack/hydra.nvim',
  },
  {
    'mrjones2014/legendary.nvim',
    cond = false,
    dependencies = {
      'stevearc/dressing.nvim',
      -- used for frecency sort
      'kkharji/sqlite.lua',
    },
    cmd = { 'Legendary', 'LegendaryRepeat' },
    keys = {
      { '<leader>;', '<cmd>LegendaryRepeat<cr>', desc = 'Legendary repeat last' },
      { '<localleader>p', '<cmd>Legendary<cr>', desc = 'Legendary' },
    },
    opts = {},
  },
  { -- FIXME: register _d, cannot set timeoutlen = 0
    'folke/which-key.nvim',
    cond = false,
    event = 'VeryLazy',
    opts = {
      plugins = { spelling = { enabled = false } },
      popup_mappings = {
        scroll_down = '<a-d>',
        scroll_up = '<a-u>',
      },
      window = { border = vim.g.border },
    },
  },
  {
    'echasnovski/mini.clue',
    lazy = false,
    cond = false,
    event = { 'CursorHold', 'CursorHoldI' },
    config = function()
      local miniclue = require('mini.clue')
      local opts = {
        delay = 0,
        -- window = { delay = 0, config = { width = 'auto' } },
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '+' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- `,` key
          { mode = 'n', keys = ',' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          -- { mode = 'n', keys = ',c', desc = 'comment' },
          { mode = 'n', keys = '<Leader>r', desc = 'rename' },
        },
        -- init = function()
        --   au('User', {
        --     pattern = 'WhichKeyRefresh',
        --     callback = function(ctx)
        --       local ok, miniclue = pcall(require, 'mini.clue')
        --       if not ok then return end
        --       vim.schedule(function()
        --         local data = ctx.data
        --         local buf = data.buffer
        --         if not api.nvim_buf_is_valid(buf) then return end
        --         miniclue.ensure_buf_triggers(buf)
        --       end)
        --     end,
        --   })
        -- end,
      }
      miniclue.setup(opts)
    end,
  },
}
