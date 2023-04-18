-- this file is to debug config of plugins

-- TODO
-- VeryLazy will hide the intromessage
-- it put some redraw event after VimEnter, 
-- classic startup: load plugins + draw intro-message -> VimEnter
-- VeryLazy startup: VimEnter -> load plugins + draw intro-message


-- another noticable:
-- the behavior of :redraw in different in nvim and vim

return {

  -- -- no redraw
  -- {
  --   'akinsho/toggleterm.nvim',
  --   event = 'VeryLazy',
  --   config = true,
  -- },
  {
    'linty-org/readline.nvim',
    keys = {
      { '<c-f>', '<right>', mode = '!' },
      { '<c-b>', '<left>', mode = '!' },
      { '<c-p>', '<up>', mode = '!' },
      { '<c-n>', '<down>', mode = '!' },
      { '<m-f>', function() require('readline').forward_word() end, mode = '!' },
      { '<m-b>', function() require('readline').backward_word() end, mode = '!' },
      { '<c-a>', function() require('readline').beginning_of_line() end, mode = '!' },
      { '<c-e>', function() require('readline').end_of_line() end, mode = '!' },
      -- { '<c-w>', function() require('readline').unix_word_rubout() end, mode = '!' },
      { '<m-bs>', function() require('readline').backward_kill_word() end, mode = '!' },
      { '<m-d>', function() require('readline').kill_word() end, mode = '!' },
      { '<c-l>', function() require('readline').kill_word() end, mode = '!' },
      { '<c-k>', function() require('readline').kill_line() end, mode = '!' },
      { '<c-u>', function() require('readline').backward_kill_line() end, mode = '!' },
    },
  },

  -- {
  --   'nvim-tree/nvim-tree.lua', tag = 'nightly',
  --   cond = false,
  --   event = 'VeryLazy',
  --   dependencies = { 'nvim-tree/nvim-web-devicons', },
  --   config = true,
  -- },

  -- {
  --   'folke/which-key.nvim',
  --   event = 'VeryLazy',
  --   cond = false,
  --   config = true,
  -- },
  --
  -- {
  --   'nvim-treesitter/nvim-treesitter-context',
  --   dependencies = 'nvim-treesitter/nvim-treesitter',
  --   event = 'VeryLazy',
  --   cond = false,
  --   config = true,
  -- },

}

-- %s/$/\=line('.')-1
