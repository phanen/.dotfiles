return {
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function() fn['mkdp#util#install']() end,
  },
  {
    'epwalsh/obsidian.nvim',
    cond = true,
    -- dependencies = { 'nvim-lua/plenary.nvim' },
    version = '*',
    -- init = function() vim.opt.conceallevel = 2 end,
    -- ft = 'markdown',
    event = {
      -- lazy.vim handle this by creating autocmd with `:h file-pattern`
      -- it's more like globbing rather than a regex...
      -- e.g. ~/notes/*.md include subdir, to fix it
      ('BufReadPre %s/notes/[^/]\\\\\\{1,30\\}.md'):format(fn.expand '~'),
      ('BufNewFile %s/notes/[^/]\\\\\\{1,30\\}.md'):format(fn.expand '~'),
    },
    cmd = {
      'ObsidianNew',
      'ObsidianToday',
      -- via external plugins
      'ObsidianOpen',
      'ObsidianTags',
      'ObsidianTOC',
    },
    keys = {
      { '+ob', '<cmd>ObsidianOpen<cr>' },
      { '+of', '<cmd>ObsidianTags<cr>' },
      { '+oq', '<cmd>ObsidianQuickSwitch<cr>' },
      { '+ot', '<cmd>ObsidianTOC<cr>' },
    },
    opts = {
      workspaces = {
        -- strict = true will spam on FileNotFoundError
        { name = 'notes', path = '~/notes', strict = false },
      },
      completion = { nvim_cmp = false, min_chars = 2 },
      mappings = {},
      follow_url_func = function(...) return vim.ui.open(...) end,
      disable_frontmatter = true,
      ---@return table
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then note:add_alias(note.title) end
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      picker = {
        name = 'telescope.nvim',
        -- name = 'fzf-lua', -- TODO(upstream): no previewer
        mappings = { -- TODO: no support
          new = '<C-x>', -- Create a new note from your query.
          insert_link = '<C-l>', -- Insert a link to the selected note.
        },
      },
      ui = { enable = false },
    },
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
