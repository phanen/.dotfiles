return {
  { 'phanen/readline.nvim', branch = 'fix-dir-structure' },
  {
    'folke/ts-comments.nvim',
    opts = {},
    event = 'VeryLazy',
    enabled = vim.fn.has('nvim-0.10.0') == 1,
    -- or we can use hook:
    -- { 'JoosepAlviste/nvim-ts-context-commentstring' },
  },
  {
    'kylechui/nvim-surround',
    keys = {
      'ys',
      'cs',
      'ds',
      { 's', mode = 'x' },
      { '`', '<Plug>(nvim-surround-visual)`', mode = 'x' },
    },
    opts = {
      keymaps = { insert = false, visual = 's' },
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
    opts = {
      fastwarp = { map = '<c-s>', cmap = '<c-s>', faster = true },
      -- support for <c-w> https://github.com/altermo/ultimate-autopair.nvim/issues/54
      -- bs = { map = { '<bs>', '<c-h>' }, cmap = { '<bs>', '<c-h>' } },
    },
    config = function(_, opts)
      -- https://github.com/altermo/ultimate-autopair.nvim/issues/82
      local ua = require 'ultimate-autopair'
      ua.init({
        ua.extend_default(opts),
        {
          profile = 'map',
          p = -1,
          { 'i', ' ', function() return vim.keycode(' <C-g>u') end },
          { 'i', '-', function() return vim.keycode('-<C-g>u') end },
        },
      })
    end,
  },
  {
    'mg979/vim-visual-multi',
    keys = {
      { '<leader>n', mode = { 'n', 'x' } },
      { [[\\A]], mode = { 'n', 'x' } },
      { [[\\/]], mode = { 'n', 'x' } },
    },
    init = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<leader>n',
        ['Find Subword Under'] = '<leader>n',
      }
    end,
  },
  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    keys = {
      { '%', mode = { 'n', 'x', 'o' } },
      { 'ds%', '"_<plug>(matchup-ds%)', mode = { 'n' } },
      { 'cs%', '"_<plug>(matchup-cs%)', mode = { 'n' } },
    },
    init = function() vim.g.matchup_surround_enabled = 1 end,
    config = function()
      vim.g.matchup_matchparen_enabled = 0
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {}
      vim.g.matchup_delim_stopline = 5000
    end,
  },
  {
    'folke/flash.nvim',
    keys = {
      { '<c-s>', function() require('flash').jump() end, mode = { 'x', 'o' } },
      { 's', function() require('flash').jump() end },
    },
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
        treesitter = { highlight = { backdrop = true } },
      },
    },
  },
  {
    'monaqa/dial.nvim',
    keys = {
      { '<c-a>', '<plug>(dial-increment)', mode = { 'n', 'x' } },
      { '<c-x>', '<plug>(dial-decrement)', mode = { 'n', 'x' } },
      { 'g<c-a>', 'g<plug>(dial-increment)', remap = true, mode = { 'n', 'x' } },
      { 'g<c-x>', 'g<plug>(dial-decrement)', remap = true, mode = { 'n', 'v' } },
    },
    config = function()
      local augend = require 'dial.augend'
      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.alias.bool,
        },
      }
    end,
  },
  {
    'chrisgrieser/nvim-various-textobjs',
    opts = {
      lookForwardSmall = 10,
      lookForwardBig = 30,
      useDefaultKeymaps = false,
      notifyNotFound = false,
    },
  },
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = { { '+u', '<Cmd>UndotreeToggle<CR>' } },
    config = function()
      vim.g.undotree_DiffAutoOpen = 0
      vim.g.undotree_HelpLine = 0
      vim.g.undotree_SetFocusWhenToggle = 1
      -- vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = math.min(math.floor(vim.go.columns), 25)
      vim.g.undotree_TreeNodeShape = '◦'
      vim.g.undotree_WindowLayout = 2
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
