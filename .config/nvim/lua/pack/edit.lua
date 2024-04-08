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
    opts = { cmap = false },
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
    init = function() vim.o.matchpairs = '(:),{:},[:],<:>' end,
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
    end,
  },
  {
    'folke/flash.nvim',
    keys = {
      { '<c-s>', function() require('flash').jump() end, mode = { 'x', 'o' } },
      { 's', function() require('flash').jump() end },
      { 'S', function() require('flash').treesitter() end, mode = { 'n', 'o' } },
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
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '<leader>u', '<Cmd>UndotreeToggle<CR>', desc = 'undotree: toggle' } },
    config = function()
      vim.g.undotree_TreeNodeShape = '◦'
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    'okuuva/auto-save.nvim',
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
      execution_message = { enabled = false },
      debounce_delay = 125,
      condition = function(bufnr)
        local utils = require 'auto-save.utils.data'
        if vim.fn.getbufvar(bufnr, '&buftype') ~= '' then return false end
        if utils.not_in(vim.fn.getbufvar(bufnr, '&filetype'), { '' }) then return true end
        return false
      end,
    },
  },
}
