return {
  { import = 'plugs' },
  { import = 'mods' },

  { 'nvim-neorocks/lz.n' },

  -- FIXME: block visual mode not work well
  { 'HiPhish/rainbow-delimiters.nvim', cond = true, event = { 'BufReadPre', 'BufNewFile' } },

  -- TODO: only apply when treesitter not available...
  { 'itchyny/vim-highlighturl', cond = false, event = 'ColorScheme' },

  { -- lsp-rename verbosely display
    'smjonas/inc-rename.nvim',
    cond = true,
    cmd = 'IncRename',
    opts = {
      -- input_buffer_type = "dressing",
      -- post_hook = function() fn.histdel('cmd', '^IncRename ') end,
    },
  },

  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },

  { 'tpope/vim-eunuch', cmd = { 'Rename', 'Delete' } },

  -- { 'Konfekt/vim-select-replace', lazy = false },
  { 'monaqa/modesearch.vim', cond = true, keys = { { 'g/', '<Plug>(modesearch-slash)' } } },
  {
    'kevinhwang91/nvim-fundo',
    cond = true,
    event = { 'BufReadPre' },
    dependencies = 'kevinhwang91/promise-async',
    build = function() require('fundo').install() end,
    opts = {},
  },

  -- translate
  { 'voldikss/vim-translator', cmd = 'Translate' },
  {
    'potamides/pantran.nvim',
    cond = true,
    cmd = 'Pantran',
    opts = {},
  },

  -- debug ex (:
  {
    'nacro90/numb.nvim',
    cond = false,
    event = 'CmdlineEnter',
    config = true,
  },

  -- TODO: vendor it
  {
    'ghostbuster91/nvim-next',
    cond = false,
    -- treesitter don't lazy-load, so needless
    -- keys = { ' dj', ' dk', ' <c-g>p', ' <c-g>n' },
    config = function()
      local next = require 'nvim-next'
      local b = require 'nvim-next.builtins'
      local i = require 'nvim-next.integrations'
      next.setup {
        default_mappings = { repeat_style = 'original' },
        -- items = { b.f, b.t },
      }
      local diag = i.diagnostic()
      local nqf = i.quickfix()
      map.n(' dk', diag.goto_prev())
      map.n(' dj', diag.goto_next())
      map.n('<c-g>p', nqf.cprevious)
      map.n('<c-g>n', nqf.cnext)
    end,
  },
}
