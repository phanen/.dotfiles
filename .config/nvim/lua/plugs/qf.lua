return {
  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      preview = {
        should_preview_cb = function(bufnr, _)
          local bufname = api.nvim_buf_get_name(bufnr)
          local fsize = fn.getfsize(bufname)
          if bufname:match '^fugitive://' then return false end
          if fsize > 100 * 1024 then return false end
          return true
        end,
      },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    opts = {},
  },
}
