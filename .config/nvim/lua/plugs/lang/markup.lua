return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() fn['mkdp#util#install']() end,
  },
  {
    'noearc/pangu.nvim',
    cond = false,
    cmd = { 'Pangu' },
    dependencies = { 'noearc/jieba-lua' },
    config = true,
  },
  { 'hotoo/pangu.vim', cmd = 'Pangu', ft = 'markdown' },
  { 'dawsers/edit-code-block.nvim', cmd = 'EditCodeBlock', opts = {} },
  -- same
  { 'AckslD/nvim-FeMaco.lua', cond = false, opts = true },

  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  {
    -- TODO(upstream): https://github.com/3rd/image.nvim/issues/116
    '3rd/image.nvim',
    -- cond = function() return (uv.fs_stat(fn.expand '~/.luarocks/share/lua/5.1/magick/')) end,
    cond = false,
    ft = { 'markdown', 'org' },
    opts = {
      -- integrations = {
      --   markdown = { only_render_image_at_cursor = true },
      -- },
      window_overlap_clear_enabled = true,
    },
  },
  { 'dhruvasagar/vim-table-mode', cond = false, ft = { 'markdown', 'org' } },
  {
    'nvim-orgmode/orgmode',
    cond = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    ft = 'org',
    opts = {
      org_agenda_files = '~/orgfiles/**/*',
      org_default_notes_file = '~/orgfiles/refile.org',
    },
  },
  {
    'nvim-neorg/neorg',
    cond = false,
    lazy = false,
    version = '*', -- Pin Neorg to the latest stable release
    config = true,
  },
  -- {
  --   'Vonr/align.nvim',
  --   branch = 'v2',
  --   lazy = true,
  --   init = function()
  --     -- Create your mappings here
  --     local NS = { noremap = true, silent = true }
  --
  --     -- Aligns to 1 character
  --     vim.keymap.set('x', 'aa', function() require 'align'.align_to_char({ length = 1 }) end, NS)
  --
  --     -- Aligns to 2 characters with previews
  --     vim.keymap.set(
  --       'x',
  --       'ad',
  --       function() require 'align'.align_to_char({ preview = true, length = 2 }) end,
  --       NS
  --     )
  --
  --     -- Aligns to a string with previews
  --     vim.keymap.set(
  --       'x',
  --       'aw',
  --       function() require 'align'.align_to_string({ preview = true, regex = false }) end,
  --       NS
  --     )
  --
  --     -- Aligns to a Vim regex with previews
  --     vim.keymap.set(
  --       'x',
  --       'ar',
  --       function() require 'align'.align_to_string({ preview = true, regex = true }) end,
  --       NS
  --     )
  --
  --     -- Example gawip to align a paragraph to a string with previews
  --     vim.keymap.set('n', 'gaw', function()
  --       local a = require 'align'
  --       a.operator(a.align_to_string, { regex = false, preview = true })
  --     end, NS)
  --
  --     -- Example gaaip to align a paragraph to 1 character
  --     vim.keymap.set('n', 'gaa', function()
  --       local a = require 'align'
  --       a.operator(a.align_to_char)
  --     end, NS)
  --   end,
  -- },
  {
    'jbyuki/nabla.nvim',
    cond = false,
    opts = true,
    init = function()
      vim.cmd [[nnoremap +p :lua require("nabla").popup()<cr> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`]]
    end,
  },
  {
    'HakonHarnes/img-clip.nvim',
    keys = { { '+p', '<cmd>PasteImage<cr>' } },
    opts = {},
  },
}
