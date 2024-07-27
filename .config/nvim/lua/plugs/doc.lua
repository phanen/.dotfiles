return {
  -- TODO: replace g c-g
  { 'jspringyc/vim-word', cmd = { 'WordCount', 'WordCountLine' } },
  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  { 'phanen/mder.nvim', ft = 'markdown' },
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
    init = function()
      package.path = package.path .. ';' .. fn.expand '~/.luarocks/share/lua/5.1/?/init.lua;'
      package.path = package.path .. ';' .. fn.expand '~/.luarocks/share/lua/5.1/?.lua;'
    end,
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
  {
    'junegunn/vim-easy-align',
    keys = { { '+ga', '<plug>(EasyAlign)', mode = { 'n', 'x' } } },
    init = function() end,
  },
  {
    'jbyuki/nabla.nvim',
    cond = false,
    opts = true,
    init = function()
      vim.cmd [[nnoremap +p :lua require("nabla").popup()<cr> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`]]
    end,
  },
  { 'HakonHarnes/img-clip.nvim', keys = { { '+p', '<cmd>PasteImage<cr>' } }, opts = {} },
  {
    'lervag/vimtex',
    -- lazy = false, -- :h :VimtexInverseSearch
    ft = 'tex',
    keys = {
      { '<leader>vc', '<cmd>VimtexCompile<cr>' },
      { '<leader>vl', '<cmd>VimtexClean<cr>' },
      { '<leader>vs', '<cmd>VimtexCompileSS<cr>' },
      { '<leader>vv', '<plug>(vimtex-view)' },
    },
    config = function()
      vim.g.vimtex_view_method = 'sioyek'
      vim.g.tex_flavor = 'xelatex'
      vim.g.tex_conceal = 'abdmgs'
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
  {
    'noearc/pangu.nvim',
    cond = false,
    cmd = { 'Pangu' },
    dependencies = {
      'noearc/jieba-lua',
      init = function()
        package.cpath = package.cpath .. ';' .. fn.expand '~/.luarocks/lib/lua/5.1/?.lua;'
      end,
    },
    config = true,
  },
  { 'hotoo/pangu.vim', cmd = 'Pangu', ft = 'markdown' },
  { 'dawsers/edit-code-block.nvim', cmd = 'EditCodeBlock', opts = {} },
  -- same
  { 'AckslD/nvim-FeMaco.lua', cond = false, opts = true },
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
      -- { '+t', '<cmd>ObsidianTags<cr>' },
      { '+t', '<cmd>ObsidianTags<cr>' },
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
      follow_url_func = vim.ui.open,
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
}
