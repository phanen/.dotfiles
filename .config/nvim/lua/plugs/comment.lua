return {
  {
    'numToStr/Comment.nvim',
    cond = false,
    -- cond = fn.has('nvim-0.10') == 0,
    keys = {
      { 'gcc' },
      { 'gc', mode = { 'n', 'x' } },
      { '<leader>O', 'gcO', remap = true },
      { '<leader>A', 'gcA', remap = true },
      { '<c-_>', '<c-/>', remap = true, mode = { 'n', 'x', 'i' } },
      {
        '<c-/>',
        function()
          return vim.v.count == 0 and '<Plug>(comment_toggle_linewise_current)'
            or '<Plug>(comment_toggle_linewise_count)'
        end,
        expr = true,
      },
      { '<c-/>', '<cmd>norm <Plug>(comment_toggle_linewise_current)<cr>', mode = 'i' },
      { '<c-/>', '<Plug>(comment_toggle_linewise_visual)', mode = 'v' },
    },
    opts = {
      pre_hook = function(...) require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(...) end,
    },
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring' },
  },
}
