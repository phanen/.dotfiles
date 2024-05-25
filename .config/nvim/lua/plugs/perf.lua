return {
  -- profile
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    cond = false,
  },
  {
    'nvim-lua/plenary.nvim',
    cmd = 'PlenaryBustedDirectory',
    keys = {
      { '+ps', function() require('plenary.profile').start('profile.log', { flame = true }) end },
      { '+pe', function() require('plenary.profile').stop() end },
    },
  },
}
