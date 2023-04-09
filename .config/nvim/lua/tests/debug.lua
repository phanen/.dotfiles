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
    'nvim-tree/nvim-tree.lua', tag = 'nightly',
    cond = false,
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons', },
    config = true,
  },

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
