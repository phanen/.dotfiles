return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  opts = {
    preview = {
      border = g.border,
      extra_opts = {
        description = 'Extra options for fzf',
        default = { '--bind', 'ctrl-q:toggle-all' },
      },
      -- should_preview_cb = function(bufnr, _)
      --   local bufname = api.nvim_buf_get_name(bufnr)
      --   local fsize = fn.getfsize(bufname)
      --   if bufname:match '^fugitive://' then return false end
      --   if fsize > 100 * 1024 then return false end
      --   return true
      -- end,
    },
  },
}
