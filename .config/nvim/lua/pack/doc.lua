return {
  { 'jspringyc/vim-word', cmd = { 'WordCount', 'WordCountLine' } },
  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  { 'phanen/mder.nvim', ft = 'markdown', opts = {} },
  {
    -- TODO: https://github.com/3rd/image.nvim/issues/116
    '3rd/image.nvim',
    cond = function() return (vim.uv.fs_stat(vim.fn.expand '~/.luarocks/share/lua/5.1/magick/')) end,
    ft = { 'markdown', 'org' },
    opts = {
      -- integrations = {
      --   markdown = { only_render_image_at_cursor = true },
      -- },
      window_overlap_clear_enabled = true,
    },
    init = function()
      package.path = package.path .. ';' .. vim.fn.expand '~/.luarocks/share/lua/5.1/?/init.lua;'
      package.path = package.path .. ';' .. vim.fn.expand '~/.luarocks/share/lua/5.1/?.lua;'
    end,
  },
}
