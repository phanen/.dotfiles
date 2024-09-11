return {
  { import = 'plugs' },
  { import = 'mods' },

  { 'nvim-neorocks/lz.n' },

  -- FIXME: block visual mode not work well
  -- FIXME: very slow on large file
  { 'HiPhish/rainbow-delimiters.nvim', cond = false, event = { 'BufReadPre', 'BufNewFile' } },

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

  -- repl (maybe needless when we has a runner/sourcer over flie)
  {
    'Vigemus/iron.nvim',
    cond = false,
    lazy = false,
    config = function()
      require('iron.core').setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { 'zsh' },
            },
            python = {
              command = { 'python3' }, -- or { "ipython", "--no-autoindent" }
              format = require('iron.fts.common').bracketed_paste_python,
            },
            lua = {
              command = { 'lua' },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          repl_open_cmd = require('iron.view').bottom(40),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = '<space>sc',
          visual_send = '<space>sc',
          send_file = '<space>sf',
          send_line = '<space>sl',
          send_paragraph = '<space>sp',
          send_until_cursor = '<space>su',
          send_mark = '<space>sm',
          mark_motion = '<space>mc',
          mark_visual = '<space>mc',
          remove_mark = '<space>md',
          cr = '<space>s<cr>',
          interrupt = '<space>s<space>',
          exit = '<space>sq',
          clear = '<space>cl',
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }
    end,
  },
}
