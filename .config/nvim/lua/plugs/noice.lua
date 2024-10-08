return {
  'folke/noice.nvim',
  cond = false,
  event = 'VeryLazy',
  dependencies = {
    -- 'MunifTanjim/nui.nvim',
    -- fallback to mini.nvim
    {
      'rcarriga/nvim-notify',
      cond = false,
      opts = {
        views = {
          mini = { border = 'rounded', position = { row = -2 }, focusable = false },
          cmdline_popup = { position = { row = '38%' } },
        },
        render = 'compact',
        top_down = true,
        on_open = function(win) api.nvim_win_set_config(win, { focusable = false }) end,
      },
    },
  },
  opts = {
    lsp = {
      progress = { enabled = false },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
    },
    routes = {
      {
        filter = { event = 'msg_show', kind = 'search_count' },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'msg_show',
          any = { { find = '%d+L, %d+B' }, { find = '; after #%d+' }, { find = '; before #%d+' } },
        },
        opts = { skip = true },
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = false,
      inc_rename = false,
      lsp_doc_border = false,
    },
  },
  keys = {
    { '<leader>ml', function() require('noice').cmd('last') end },
    { '<leader>mh', function() require('noice').cmd('history') end },
    { '<leader>ma', function() require('noice').cmd('all') end },
    { '<leader>mk', function() require('noice').cmd('dismiss') end },
  },
}
