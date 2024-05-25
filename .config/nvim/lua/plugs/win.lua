return {
  -- use zen mode
  {
    'szw/vim-maximizer',
    cond = false,
    init = function() vim.g.maximizer_set_mapping_with_bang = 1 end,
    cmd = 'MaximizerToggle',
    lazy = false,
  },
  -- TODO: zen mode but not hide bar
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    keys = { { '+z', '<cmd>ZenMode<cr>' } },
    opts = {

      window = {
        backdrop = 1,
        width = 85, -- width of the Zen window
        height = 1, -- height of the Zen window
      },
      plugins = {
        kitty = { enabled = true, font = '+1' },
      },
    },
  },
}
