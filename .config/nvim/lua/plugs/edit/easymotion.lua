return {
  'folke/flash.nvim',
  keys = {
    -- { '<c-s>', function() require('flash').jump() end, mode = { 'x', 'o' } },
    { 's', function() require('flash').jump() end },
  },
  opts = {
    modes = {
      search = { enabled = false },
      char = { enabled = false },
      treesitter = { highlight = { backdrop = true } },
    },
  },
}
