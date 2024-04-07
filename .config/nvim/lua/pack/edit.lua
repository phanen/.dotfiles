return {
  { 'phanen/readline.nvim', branch = 'fix-dir-structure' },
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'yss',
      'yS',
      'cs',
      'ds',
      { 's', mode = 'x' },
      { '`', '<Plug>(nvim-surround-visual)`', mode = 'x' },
    },
    opts = {
      keymaps = { visual = 's' },
      surrounds = {
        ['j'] = {
          add = { '**', '**' },
          find = '%*%*.-%*%*',
          delete = '^(%*%*?)().-(%*%*?)()$',
        },
        ['M'] = { add = { '$$', '$$' } },
        ['['] = { add = { '[[ ', ' ]]' } },
      },
      aliases = {
        ['n'] = '}',
        ['q'] = '"',
        ['m'] = '$',
      },
    },
  },
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    -- cond = false,
    opts = { cmap = false },
  },
  {
    'windwp/nvim-autopairs',
    cond = false,
    event = 'InsertEnter',
    dependencies = { 'hrsh7th/nvim-cmp' },
    opts = {},
  },
  {
    'mg979/vim-visual-multi',
    keys = {
      { '<leader>n', mode = { 'n', 'x' } },
      { '\\\\A', mode = { 'n', 'x' } },
      { '\\\\/', mode = { 'n', 'x' } },
    },
    init = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<leader>n',
        ['Find Subword Under'] = '<leader>n',
      }
    end,
  },
  {
    'andymass/vim-matchup', -- TODO: slow when use flash.nvim
    event = 'BufReadPost',
    keys = { mode = { 'n', 'x', 'o' }, '%' },
    init = function()
      vim.o.matchpairs = '(:),{:},[:],<:>'
    end,
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    'folke/flash.nvim',
    keys = {
      {
        's',
        mode = { 'n' },
        function()
          require('flash').jump({
            search = {
              mode = function(str)
                return '\\<' .. str
              end,
            },
          })
        end,
        desc = 'Flash',
      },
      {
        '<c-s>',
        mode = { 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
    },
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
        treesitter = { labels = 'asdfghjklqwertyuiopzxcvbnm', highlight = { backdrop = true } },
      },
    },
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        json = { 'prettier' },
        fish = { 'fish_indent' },
      },
    },
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<c-a>', '<plug>(dial-increment)', mode = { 'n', 'x' } },
      { '<c-x>', '<plug>(dial-decrement)', mode = { 'n', 'x' } },
      { 'g<c-a>', 'g<plug>(dial-increment)', mode = { 'n', 'x' } },
      { 'g<c-x>', 'g<plug>(dial-decrement)', mode = { 'n', 'x' } },
      { '<c-a>', '<plug>(dial-increment)', mode = { 'n', 'x' } },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
        },
      }
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    opts = { useDefaultKeymaps = false },
  },
}
