return {
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
    -- TODO: slow on large file (treesitter?)
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
          {
            'i',
            ' ',
            function()
              if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then
                return vim.keycode(' ')
              end
              return vim.keycode(' <C-g>u')
            end,
          },
          {
            'i',
            '-',
            function()
              if fn.reg_recording() ~= '' or fn.reg_executing() ~= '' then
                return vim.keycode('-')
              end
              return vim.keycode('-<C-g>u')
            end,
          },
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
      { 'g<c-x>', 'g<plug>(dial-decrement)', remap = true, mode = { 'n', 'x' } },
      { ' <c-a>', '"=p<cr><plug>(dial-increment)', mode = { 'n', 'x' } },
      { ' <c-x>', '"=p<cr><plug>(dial-decrement)', mode = { 'n', 'x' } },
      { '+<c-a>', '"=digit<cr><plug>(dial-increment)', mode = { 'n', 'x' } },
      { '+<c-x>', '"=digit<cr><plug>(dial-decrement)', mode = { 'n', 'x' } },
    },
    config = function()
      local augend = require 'dial.augend'
      local find_pattern = require('dial.augend.common').find_pattern

      local and_or_sym = augend.constant.new {
        elements = { '&&', '||' },
        word = false,
        cyclic = true,
      }
      local and_or = augend.constant.new {
        elements = { 'and', 'or' },
        word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
        cyclic = true, -- "or" is incremented into "and".
      }

      local oct = augend.user.new {
        find = find_pattern('0%[0-7]+'),
        add = function(text, addend, _)
          if addend > 0 then
            text = ('0x%x'):format(tonumber(text, 8))
          else
            text = tostring(tonumber(text, 8))
          end
          return { text = text, cursor = #text }
        end,
      }
      local hex = augend.user.new {
        find = find_pattern('0x%x+'),
        add = function(text, addend, _)
          if addend > 0 then
            text = tostring(tonumber(text))
          else
            text = ('0%o'):format(text)
          end
          return { text = text, cursor = #text }
        end,
      }
      local dec = augend.user.new {
        find = find_pattern('%d+'),
        add = function(text, addend, _)
          if addend > 0 then
            text = ('0x%x'):format(tonumber(text))
          else
            text = ('0%o'):format(text)
          end
          return { text = text, cursor = #text }
        end,
      }

      local square = augend.user.new {
        find = find_pattern('%d+'),
        add = function(text, addend, cursor)
          local n = tonumber(text)
          n = math.floor(n * (2 ^ addend))
          text = tostring(n)
          cursor = #text
          return { text = text, cursor = cursor }
        end,
      }

      require('dial.config').augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
          augend.constant.alias.bool,
          and_or_sym,
          and_or,
        },
        digit = { oct, hex, dec },
        p = { square },
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
    cond = true,
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
    'jiaoshijie/undotree',
    cond = false,
    main = 'undotree',
    name = 'undotree-nvim',
    opts = true,
  },
  {
    'okuuva/auto-save.nvim',
    cond = true,
    event = { 'InsertLeave', 'TextChanged' },
    opts = {
      execution_message = { enabled = false },
      debounce_delay = 125,
      condition = function(bufnr)
        local utils = require 'auto-save.utils.data'
        if fn.getbufvar(bufnr, '&buftype') ~= '' then return false end
        if utils.not_in(fn.getbufvar(bufnr, '&filetype'), { '' }) then return true end
        return false
      end,
    },
  },
  {
    'windwp/nvim-ts-autotag',
    -- event = 'InsertEnter',
    ft = { 'markdown', 'xml', 'html' },
    opts = {
      opts = {
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
  },
  {
    'mizlan/iswap.nvim',
    cmd = {
      'ISwap',
      'ISwapWith',
      'ISwapNode',
      'ISwapNodeWith',
      'ISwapWithLeft',
      'ISwapWithRight',
      'ISwapNodeWithLeft',
      'ISwapNodeWithRight',
    },
    opts = {
      flash_style = true,
      move_cursor = true,
    },
  },
  {
    'cshuaimin/ssr.nvim',
    keys = { { '+s', function() require('ssr').open() end, mode = { 'n', 'x' } } },
    opts = {
      border = vim.g.border,
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = 'q',
        next_match = 'n',
        prev_match = 'N',
        replace_confirm = '<cr>',
        replace_all = '<leader><cr>',
      },
    },
  },
  {
    'gbprod/substitute.nvim',
    keys = {
      { 'g_', function() require('substitute.exchange').operator() end, mode = 'n' },
      { 'g_', function() require('substitute.exchange').visual() end, mode = 'x' },
    },
    opts = {},
  },
  {
    'ThePrimeagen/refactoring.nvim',
    keys = {
      { '<leader>re', ':Refactor extract ', mode = 'x' },
      { '<leader>rf', ':Refactor extract_to_file ', mode = 'x' },
      { '<leader>rv', ':Refactor extract_var ', mode = 'x' },
      { '<leader>ri', ':Refactor inline_var', mode = { 'n', 'x' } },
      { '<leader>rI', ':Refactor inline_func', mode = 'n' },
      { '<leader>rb', ':Refactor extract_block', mode = 'n' },
      { '<leader>rbf', ':Refactor extract_block_to_file', mode = 'n' },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function() require('refactoring').setup() end,
  },
  {
    'AndrewRadev/splitjoin.vim',
    cond = false, -- lazy = false,
    keys = 'gJ',
  },
  {
    'kevinhwang91/nvim-hlslens',
    keys = {
      {
        'n',
        [[<cmd>execute('normal! ' . v:count1 . 'n') | lua require('hlslens').start()<cr>zz]],
      },
      {
        'N',
        [[<cmd>execute('normal! ' . v:count1 . 'N') | lua require('hlslens').start()<cr>zz]],
      },
      {
        '*',
        [[*<cmd>lua require('hlslens').start()<cr>]],
        { remap = true },
      },
      { '#', [[#<cmd>lua require('hlslens').start()<cr>]] },
      { 'g*', [[g*<cmd>lua require('hlslens').start()<cr>]] },
      { 'g#', [[g#<cmd>lua require('hlslens').start()<cr>]] },
      {
        '<esc>',
        function()
          vim.cmd.noh()
          require('hlslens').stop()
          api.nvim_feedkeys(vim.keycode('<esc>'), 'n', false)
        end,
      },
    },
    opts = { calm_down = true, nearest_only = true },
  },
}
