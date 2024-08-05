return {
  {
    -- https://github.com/akinsho/bufferline.nvim/issues/196
    'akinsho/bufferline.nvim',
    version = '*',
    cond = true,
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = { 'BufferLineMovePrev', 'BufferLineMoveNext' },
    opts = {
      options = {
        tab_size = 10,
        enforce_regular_tabs = false,
        show_buffer_close_icons = false,
        hover = { enabled = false },
        offsets = {
          { filetype = 'NvimTree', text = 'NvimTree', text_align = 'center' },
          { filetype = 'undotree', text = 'UNDOTREE', text_align = 'center' },
        },
      },
    },
  },
}
