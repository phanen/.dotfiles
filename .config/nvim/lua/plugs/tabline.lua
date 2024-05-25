-- if use notify
-- local recording = function()
--   local reg = fn.reg_recording()
--   if reg ~= '' then return 'recording @' .. reg end
--   reg = fn.reg_recorded()
--   if reg ~= '' then return 'recorded @' .. reg end
--   return ''
-- end

-- {
--   'mode',
--   fmt = function(str) return str:sub(1, 1) end,
--   separator = { left = '', right = '' },
--   padding = { left = 0, right = 0 },
-- },

return {
  {
    'romgrk/barbar.nvim',
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {},
  },
  {
    'mg979/tabline.nvim',
    cond = false,
    event = { 'BufReadPre', 'BufNewFile' },
    init = function() vim.o.showtabline = 2 end,
    opts = {},
    config = function(_, opts)
      local tabline = require 'tabline.setup'
      tabline.setup(opts)
      tabline.mappings(true)
    end,
  },
  {
    'nanozuki/tabby.nvim',
    cond = false,
    -- init = function() vim.o.showtabline = 2 end,
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = true,
  },
  {
    'ThePrimeagen/harpoon',
    cond = false,
    branch = 'harpoon2',
    opts = {},
    keys = {
      { '<leader>H', function() require('harpoon'):list():add() end },
      {
        '<leader><c-h>',
        function()
          local harpoon = require('harpoon')
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = 'Harpoon quick menu',
      },
      { '<leader>1', function() require('harpoon'):list():select(1) end },
      { '<leader>2', function() require('harpoon'):list():select(2) end },
      { '<leader>3', function() require('harpoon'):list():select(3) end },
      { '<leader>4', function() require('harpoon'):list():select(4) end },
      { '<leader>5', function() require('harpoon'):list():select(5) end },
    },
  },
  -- indent line
  {
    'lukas-reineke/indent-blankline.nvim',
    cond = false,
    event = { 'BufRead', 'BufNewFile' },
    main = 'ibl',
    opts = { scope = { enabled = true } },
  },
  {
    'shellRaining/hlchunk.nvim',
    cond = false,
    event = { 'BufRead', 'BufNewFile' },
    opts = {
      chunk = { enable = false },
      indent = { enable = true, use_treesitter = false },
      line_num = { enable = false },
      blank = { enable = false, chars = { '․' } },
    },
  },
}
