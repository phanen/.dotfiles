return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  cond = true,
  opts = {
    preview = {
      border = g.border,
      extra_opts = { '--bind', 'ctrl-q:toggle-all' },
      should_preview_cb = function(bufnr, _)
        local bufname = api.nvim_buf_get_name(bufnr)
        local fsize = fn.getfsize(bufname)
        return fsize < 100 * 1024 and not bufname:match '^fugitive://'
      end,
    },
  },

  filter = {
    fzf = {
      action_for = {
        ['ctrl-t'] = 'tabedit',
        ['ctrl-v'] = 'vsplit',
        ['ctrl-x'] = 'split',
        ['ctrl-q'] = 'fuck', -- 'signtoggle',
        ['ctrl-c'] = 'closeall',
      },
      extra_opts = { '--bind', 'ctrl-q:toggle-all' },
    },
  },
}
