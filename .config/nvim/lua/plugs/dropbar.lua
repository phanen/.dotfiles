return {
  'Bekaboo/dropbar.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { -- fzf support
    -- 'nvim-telescope/telescope-fzf-native.nvim',
  },
  config = function()
    g.winbar = '%{%v:lua.dropbar.get_dropbar_str()%}'
    require('dropbar').setup {
      general = {
        enable = function(buf, win, _)
          if vim.bo[buf].ft == 'fugitiveblame' then return true end
          return fn.win_gettype(win) == ''
            and vim.wo[win].winbar == ''
            and vim.bo[buf].bt == ''
            and u.is.has_ts(buf)
        end,
      },
    }
  end,
}
