return {
  {
    'famiu/bufdelete.nvim',
    lazy = false,
  },

  {
    "voldikss/vim-browser-search",
    event = "VeryLazy",
    config = function()
      vim.cmd [[
        vmap <silent> <Leader>s <Plug>SearchVisual
      ]]
    end
    -- keys = {
    --   "<leader>s", mode = { "x" },
    -- }

  },

  -- {
  --   'mrjones2014/smart-splits.nvim',
  --   config = true,
  --   build = './kitty/install-kittens.bash',
  --   keys = {
  --     { '<a-h>',             function() require('smart-splits').resize_left() end },
  --     { '<a-l>',             function() require('smart-splits').resize_right() end },
  --     -- moving between splits
  --     { '<c-h>',             function() require('smart-splits').move_cursor_left() end },
  --     { '<c-j>',             function() require('smart-splits').move_cursor_down() end },
  --     { '<c-k>',             function() require('smart-splits').move_cursor_up() end },
  --     { '<c-l>',             function() require('smart-splits').move_cursor_right() end },
  --     -- swapping buffers between windows
  --     { '<leader><leader>h', function() require('smart-splits').swap_buf_left() end,    desc = { 'swap left' } },
  --     { '<leader><leader>j', function() require('smart-splits').swap_buf_down() end,    { desc = 'swap down' } },
  --     { '<leader><leader>k', function() require('smart-splits').swap_buf_up() end,      { desc = 'swap up' } },
  --     { '<leader><leader>l', function() require('smart-splits').swap_buf_right() end,   { desc = 'swap right' } },
  --   },
  -- },

}
