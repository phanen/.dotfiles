return {
  -- TODO: replace g c-g
  { 'jspringyc/vim-word', cmd = { 'WordCount', 'WordCountLine' } },
  { 'cissoid/vim-fullwidth-punct-convertor', cmd = 'FullwidthPunctConvert' },
  { 'phanen/mder.nvim', ft = 'markdown' },
  {
    -- TODO: https://github.com/3rd/image.nvim/issues/116
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
    dependencies = {
      {
        'vhyrro/luarocks.nvim',
        priority = 1000,
        config = true,
      },
    },
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
    cond = false,
    version = '*', -- recommended, use latest release instead of latest commit
    -- init = function() vim.opt.conceallevel = 2 end,
    ft = 'markdown',
    cmd = { 'ObsidianNew', 'ObsidianSwitch', 'ObsidianToday' },
    opts = {
      workspaces = {
        -- strict = true will spam on FileNotFoundError
        { name = 'notes', path = '~/notes', strict = false },
      },
      ui = { enable = false },
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        end
        local suffix = ''
        -- If title is nil, just add 4 random uppercase letters to the suffix.
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. '-' .. suffix
      end,
    },
  },
}
