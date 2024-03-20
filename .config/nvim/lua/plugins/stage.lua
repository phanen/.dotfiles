return {
  -- module
  { 'rktjmp/lush.nvim' },

  {
    'seandewar/bad-apple.nvim',
    cmd = 'BadApple',
  },
  {
    'echasnovski/mini.nvim',
  },
  {
    '4e554c4c/darkman.nvim',
    cond = false,
    event = 'VeryLazy',
    build = 'go build -o bin/darkman.nvim',
    opts = { colorscheme = { dark = 'tokyonight', light = 'github_light' } },
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
    'dawsers/navigator.nvim',
    cond = false,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter' },
    },
    keys = {
      {
        '<space><c-n>',
        function()
          require('navigator').navigate {
            query_list = {
              {
                -- Each query has to specify the parser it applies to.
                -- It is the only required parameter.
                parser = 'markdown',
                -- This trees-sitter query will create captions for Markdown headers
                query = [[
        [
          (atx_heading (atx_h1_marker))
          (atx_heading (atx_h2_marker))
          (atx_heading (atx_h3_marker))
          (atx_heading (atx_h4_marker))
          (atx_heading (atx_h5_marker))
          (atx_heading (atx_h6_marker))
          (setext_heading (setext_h1_underline))
          (setext_heading (setext_h2_underline))
        ] @definition.header

        ((atx_heading (atx_h1_marker)) @definition.header.h1)
        ((atx_heading (atx_h2_marker)) @definition.header.h2)
        ((atx_heading (atx_h3_marker)) @definition.header.h3)
        ((atx_heading (atx_h4_marker)) @definition.header.h4)
        ((atx_heading (atx_h5_marker)) @definition.header.h5)
        ((atx_heading (atx_h6_marker)) @definition.header.h6)
        ((setext_heading (setext_h1_underline)) @definition.header.h1)
        ((setext_heading (setext_h2_underline)) @definition.header.h2)
      ]],
                -- You can also add regex queries that will result in captions with
                -- `name`. The `expr` is a vim regular expression. You can add as many
                -- as you want per query
                regex = {
                  { name = 'definition.regex_tag', expr = [[#[a-zA-Z_\-\/][0-9a-zA-Z_\-\/]*]] },
                },
              },
              {
                parser = 'lua',
                -- navigator.nvim includes a `read_file` function for convenience. It can
                -- read any query file into a string
                -- This query is the result of reading a `locals.scm` query file in
                -- Neovim's runtime path, probably from nvim-treesitter
                query = require('navigator.queries').read_file(
                  vim.api.nvim_get_runtime_file(
                    string.format('queries/%s/%s.scm', 'lua', 'locals'),
                    true
                  )[1]
                ),
              },
            },
          }
        end,
      },
    },
    config = function()
      -- A query list is an array or queries. You can have as many queries you
      -- want per language, but each query can include many captures too.
    end,
  },
  -- using lazy.nvim
  {
    'LintaoAmons/cd-project.nvim',
    cmd = { 'CdProjectAdd', 'CdProjectBack', 'CdProjectSwitch' },
    config = function()
      require('cd-project').setup({
        -- this json file is acting like a database to update and read the projects in real time.
        -- So because it's just a json file, you can edit directly to add more paths you want manually
        projects_config_filepath = vim.fs.normalize(
          vim.fn.stdpath('config') .. '/cd-project.nvim.json'
        ),
        -- this controls the behaviour of `CdProjectAdd` command about how to get the project directory
        project_dir_pattern = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod' },
        choice_format = 'both', -- optional, you can switch to "name" or "path"
        projects_picker = 'vim-ui', -- optional, you can switch to `telescope`
        -- do whatever you like by hooks
        hooks = {
          {
            callback = function(dir)
              vim.notify('switched to dir: ' .. dir)
            end,
          },
          {
            callback = function(_)
              vim.cmd('Telescope find_files')
            end,
          },
          {
            callback = function(dir)
              vim.notify('switched to dir: ' .. dir)
            end, -- required, action when trigger the hook
            name = 'cd hint', -- optional
            order = 1, -- optional, the exection order if there're multiple hooks to be trigger at one point
            pattern = 'cd-project.nvim', -- optional, trigger hook if contains pattern
            trigger_point = 'DISABLE', -- optional, enum of trigger_points, default to `AFTER_CD`
            match_rule = function(dir) -- optional, a function return bool. if have this fields, then pattern will be ignored
              return true
            end,
          },
        },
      })
    end,
  },
  {
    'riddlew/asciitree.nvim',
    cmd = 'AsciiTree',
  },
  -- TODO: show recent file only
  {
    'danielfalk/smart-open.nvim',
    branch = '0.2.x',
    -- keys = { { '<leader>fo', '<cmd>Telescope smart_open<cr>', mode = { 'n', 'x' } } },
    config = function()
      require('telescope').load_extension('smart_open')
    end,
    dependencies = {
      'kkharji/sqlite.lua',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    },
  },
  {
    'smartpde/telescope-recent-files',
    keys = { { '<leader>fo', '<cmd>Telescope smart_open<cr>', mode = { 'n', 'x' } } },
    dependencies = {
      { 'nvim-telescope/telescope.nvim' },
    },
  },
  -- optional for icons

  -- optional for the 'fzf' command
  {
    'linrongbin16/fzfx.nvim',
    cmd = 'FzfxFiles',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'junegunn/fzf' },
    version = 'v5.*',
    config = true,
  },
  {
    'svermeulen/vim-subversive',
    keys = {
      {
        mode = { 'n', 'x' },
        '<localleader>s',
        '<plug>(SubversiveSubstituteRange)',
      },
      {
        '<localleader>S',
        '<plug>(SubversiveSubstituteWordRange)',
      },
    },
  },
  {
    '9seconds/repolink.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = {
      'RepoLink',
    },

    opts = {
      -- your configuration goes here.
      -- keep empty object if you are fine with defaults
    },
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
}
