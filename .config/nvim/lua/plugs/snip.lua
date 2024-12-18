return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  build = 'make install_jsregexp',
  dependencies = 'rafamadriz/friendly-snippets',
  config = function()
    require('luasnip.loaders.from_lua').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load() -- find all package.json{,c} in rtp
    -- require('luasnip.loaders.from_vscode').lazy_load { paths = './snippets' }
    require('luasnip').filetype_extend('all', { '_' })

    local types = require 'luasnip.util.types'
    require('luasnip').setup {
      update_events = { 'TextChanged', 'TextChangedI' },
      region_check_events = { 'CursorMoved', 'CursorMovedI' },
      delete_check_events = { 'TextChanged', 'TextChangedI', 'InsertEnter' },
      -- update_events = { 'TextChanged', 'TextChangedI', 'InsertEnter', 'CursorMoved', 'CursorMovedI', 'InsertLeave' },
      -- region_check_events = { 'TextChanged', 'TextChangedI', 'InsertEnter', 'CursorMoved', 'CursorMovedI', 'InsertLeave' },
      -- delete_check_events = { 'TextChanged', 'TextChangedI', 'InsertEnter', 'CursorMoved', 'CursorMovedI', 'InsertLeave' },
      ext_opts = {
        [types.choiceNode] = {
          active = { virt_text = { { '●', 'Operator' } }, virt_text_pos = 'inline' },
          unvisited = { virt_text = { { '●', 'Comment' } }, virt_text_pos = 'inline' },
        },
        [types.insertNode] = {
          active = { virt_text = { { '●', 'Keyword' } }, virt_text_pos = 'inline' },
          unvisited = { virt_text = { { '●', 'Comment' } }, virt_text_pos = 'inline' },
        },
      },
    }
  end,
}
