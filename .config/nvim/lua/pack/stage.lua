_G.lazy_cfg = package.loaded['lazy.core.config']

return {
  { 'rktjmp/lush.nvim' },
  { 'seandewar/bad-apple.nvim', cmd = 'BadApple' },
  {
    '4e554c4c/darkman.nvim',
    -- lazy = false,
    build = 'go build -o bin/darkman.nvim',
    opts = { colorscheme = { dark = vim.g.colors_name, light = 'github_light' } },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufRead', 'BufNewFile' },
    main = 'ibl',
    opts = {
      scope = { enabled = false },
    },
  },
  {
    'dawsers/edit-code-block.nvim',
    cmd = 'EditCodeBlock',
    opts = {},
  },
  { 'tpope/vim-repeat', cond = false, lazy = false },
  { 'tpope/vim-rsi', cond = false },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake',
        config = function()
          require('telescope').load_extension 'fzf'
        end,
      },
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>fb', '<cmd>Telescope builtin<cr>' },
    },
    config = function()
      local ta = require 'telescope.actions'
      local tas = require 'telescope.actions.state'
      local tal = require 'telescope.actions.layout'
      require('telescope').setup {
        defaults = {
          sorting_strategy = 'ascending',
          preview = { hide_on_startup = true },
          layout_config = {
            horizontal = { height = 0.65, preview_width = 0.55 },
            prompt_position = 'top',
          },
          file_ignore_patterns = { 'LICENSE', '*-lock.json' },
          mappings = {
            i = {
              ['<c-n>'] = ta.cycle_history_next,
              ['<c-p>'] = ta.cycle_history_prev,
              ['<c-u>'] = false,
              ['<c-d>'] = ta.preview_scrolling_down,
              ['<c-v>'] = false,
              ['<c-\\>'] = tal.toggle_preview,
              ['<esc>'] = ta.close,
              ['<c-j>'] = ta.move_selection_next,
              ['<c-k>'] = ta.move_selection_previous,
              ['<a-m>'] = tal.toggle_mirror,
              ['<a-p>'] = tal.cycle_layout_prev,
              ['<a-n>'] = tal.cycle_layout_next,
              ['<c-l>'] = function(_)
                local entry = tas.get_selected_entry()
                if entry == nil then
                  return true
                end
                local prompt_text = entry.text or entry[1]
                vim.fn.setreg('+', prompt_text)
                vim.api.nvim_paste(prompt_text, true, 1)
                return true
              end,
              ['<c-o>'] = function(bufnr)
                ta.select_default(bufnr)
                require('telescope.builtin').resume()
              end,
              ['<c-s>'] = ta.add_selected_to_qflist,
              ['<cr>'] = function(bufnr)
                local picker = tas.get_current_picker(bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                  ta.close(bufnr)
                  vim.iter(multi):each(function(v)
                    vim.cmd.e(v.path)
                  end)
                else
                  ta.select_default(bufnr)
                end
              end,
            },
          },
        },
      }
    end,
  },
  {
    'svermeulen/vim-subversive',
    -- keys = {
    --   {
    --     mode = { 'n', 'x' },
    --     '<localleader>s',
    --     '<plug>(SubversiveSubstituteRange)',
    --   },
    --   {
    --     '<localleader>S',
    --     '<plug>(SubversiveSubstituteWordRange)',
    --   },
    -- },
  },
  { 'liangxianzhe/floating-input.nvim', opts = {} },
  {
    'SuperBo/fugit2.nvim',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/plenary.nvim',
      {
        'chrisgrieser/nvim-tinygit',
        dependencies = { 'stevearc/dressing.nvim' },
      },
    },
    cmd = { 'Fugit2', 'Fugit2Graph' },
    keys = {
      { '<leader>F', mode = 'n', '<cmd>Fugit2<cr>' },
    },
  },
  { 'voldikss/vim-hello-word' },
  { 'phanen/word.nvim' },
  { 'SidOfc/carbon.nvim', cmd = 'Carbon', opts = true },
  {
    'jbyuki/nabla.nvim',
    -- opts = true,
    keys = {},
    init = function()
      vim.cmd [[nnoremap +p :lua require("nabla").popup()<CR> " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`]]
    end,
  },
  {
    'junegunn/vim-easy-align',
    keys = { { 'ga', '<plug>(EasyAlign)', mode = { 'n', 'x' } } },
    init = function() end,
  },
  { 'roginfarrer/fzf-lua-lazy.nvim' },
  { 'itchyny/vim-highlighturl', event = 'ColorScheme' },
  {
    'sontungexpt/url-open',
    cond = false,
    branch = 'mini',
    event = 'VeryLazy',
    cmd = 'URLOpenUnderCursor',
    config = function()
      local status_ok, url_open = pcall(require, 'url-open')
      if not status_ok then
        return
      end
      url_open.setup {}
    end,
  },

  {
    'nvim-lua/plenary.nvim',
    -- stylua: ignore
    keys = {
      { '+ps', function() require('plenary.profile').start('profile.log', { flame = true }) end },
      { '+pe', function() require('plenary.profile').stop() end },
    },
  },
  {
    'NStefan002/2048.nvim',
    cmd = 'Play2048',
    opts = {},
  },
  { 'chrisbra/csv.vim', ft = 'csv' },
  --
  { 'sbulav/nredir.nvim', cmd = 'Nredir' },
  {
    'tani/dmacro.nvim',
    cond = false,
    opts = { dmacro_key = '+.' },
  },
  {
    url = 'https://github.com/tani/pickup.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  {
    url = 'https://github.com/tamton-aquib/keys.nvim',
    cmd = 'KeysToggle',
  },
  {
    url = 'https://github.com/Febri-i/snake.nvim',
    cmd = 'SnakeStart',
    opts = {},
    dependencies = {
      url = 'https://github.com/Febri-i/fscreen.nvim',
    },
  },
  {
    'NStefan002/speedtyper.nvim',
    cmd = 'Speedtyper',
    opts = {
      -- your config
    },
  },
  {
    'Rawnly/gist.nvim',
    cmd = { 'GistCreate', 'GistCreateFromFile', 'GistsList' },
    config = true,
  },
  {
    url = 'https://github.com/neovim/nvimdev.nvim',
    cmd = { 'NvimTestRun', 'NvimTestClear' },
    config = true,
  },
  {
    url = 'https://github.com/noearc/pangu.nvim',
    cmd = { 'Pangu' },
    dependencies = {
      url = 'https://github.com/noearc/jieba-lua',
      init = function()
        package.cpath = package.cpath .. ';' .. vim.fn.expand '~/.luarocks/lib/lua/5.1/?.lua;'
      end,
    },
    config = true,
  },
  {
    'hotoo/pangu.vim',
    -- keys = { { mode = 'x', '<leader>lj', ':Pangu<cr>' } },
    cmd = 'Pangu',
    ft = 'markdown',
  },
  {
    'andrewferrier/debugprint.nvim',
    keys = { 'g?p' },
    opts = {
      keymaps = {
        normal = {
          plain_below = 'g?p',
          plain_above = 'g?P',
          variable_below = 'g?v',
          variable_above = 'g?V',
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = 'g?o',
          textobj_above = 'g?O',
          toggle_comment_debug_prints = nil,
          delete_debug_prints = nil,
        },
        visual = {
          variable_below = 'g?v',
          variable_above = 'g?V',
        },
      },
      commands = {
        toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
        delete_debug_prints = 'DeleteDebugPrints',
      },
    },
  },
}
