return {
  {
    'skywind3000/asyncrun.vim',
    cmd = 'AsyncRun',
    cond = false,
  },
  {
    'tpope/vim-dispatch',
    cond = false,
    cmd = {
      'Dispatch',
      'Make',
      'Focus',
      'FocusDispatch',
      'Start',
      'Copen',
      'AbortDispatch',
    },
    config = function() end,
    init = function()
      vim.g.dispatch_no_maps = 1
      vim.g.dispatch_no_tmux_make = 1 -- do not use tmux strategy in tmux.
    end,
  },
  -- 太特么复杂了
  -- {
  --   'stevearc/overseer.nvim',
  --   cond = false,
  --   keys = {
  --     { '+or', '<cmd>OverseerRun<CR>', desc = 'Run' },
  --     { '+ot', '<cmd>OverseerToggle<CR>', desc = 'List' },
  --     { '+ob', '<cmd>OverseerBuild<CR>', desc = 'New' },
  --     { '+oa', '<cmd>OverseerTaskAction<CR>', desc = 'Action' },
  --     { '+oi', '<cmd>OverseerInfo<CR>', desc = 'Info' },
  --     { '+oc', '<cmd>OverseerClearCache<CR>', desc = 'Clear cache' },
  --   },
  --   opts = {
  --     strategy = { 'toggleterm', quit_on_exit = 'success', open_on_start = false },
  --     task_list = {
  --       -- direction = 'bottom',
  --     },
  --     dap = false,
  --   },
  --   config = function(_, opts)
  --     local overseer = require 'overseer'
  --     overseer.setup(opts)
  --     do -- For lazy loading lualine component
  --       local success, lualine = pcall(require, 'lualine')
  --       if not success then return end
  --       local lualine_cfg = lualine.get_config()
  --       for i, item in ipairs(lualine_cfg.sections.lualine_x) do
  --         if type(item) == 'table' and item.name == 'overseer-placeholder' then
  --           lualine_cfg.sections.lualine_x[i] = 'overseer'
  --         end
  --       end
  --       lualine.setup(lualine_cfg)
  --     end
  --
  --     local templates = {
  --       {
  --         name = 'C++ build',
  --         builder = function()
  --           return {
  --             cmd = { 'c++' },
  --             args = { '-g', fn.expand '%:p', '-o', fn.expand '%:p:t:r' },
  --           }
  --         end,
  --         condition = { filetype = { 'cpp' } },
  --       },
  --       {
  --         name = 'C build',
  --         builder = function()
  --           return {
  --             cmd = { 'cc' },
  --             args = { '-g', fn.expand '%:p', '-o', fn.expand '%:p:t:r' },
  --           }
  --         end,
  --         condition = { filetype = { 'c' } },
  --       },
  --       -- TODO: pipeline
  --       {
  --         name = 'run',
  --         builder = function()
  --           return {
  --             cmd = { './a' },
  --             args = { '-g', fn.expand '%:p', '-o', fn.expand '%:p:t:r' },
  --           }
  --         end,
  --         condition = { filetype = { 'c' } },
  --       },
  --     }
  --     for _, template in ipairs(templates) do
  --       overseer.register_template(template)
  --     end
  --   end,
  -- },
  -- 最简单好用的, 但是会自动 toggle 到 窗口里面...
  -- TODO: buf mode not found?
  {
    'CRAG666/code_runner.nvim',
    cond = false,
    keys = { { '<leader>wr', '<cmd>RunCode<cr><cmd>wincmd w<cr>' } },
    cmd = 'RunCode',
    opts = {
      mode = 'term',
      -- startinsert = true,
    },
  },
  -- terminal 不清除历史 ...
  {
    'michaelb/sniprun',
    cond = true,
    cmd = 'SnipRun',
    build = 'bash install.sh',
    keys = {
      { '<leader>wr', ':%SnipRun<cr>' },
      { '<leader>wr', ':SnipRun<cr>', mode = { 'x' } },
    },
    opts = {
      live_mode_toggle = 'enable',
      display = {
        -- 'Classic', --# display results in the command-line  area
        -- 'VirtualTextOk', --# display ok results as virtual text (multiline is shortened)
        -- "VirtualText",             --# display results as virtual text
        -- 'TempFloatingWindow', --# display results in a floating window
        -- 'LongTempFloatingWindow', --# same as above, but only long results. To use with VirtualText[Ok/Err]
        'Terminal', --# display results in a vertical split
        -- 'TerminalWithCode', --# display results and code history in a vertical split
        -- "NvimNotify",              --# display with the nvim-notify plugin
        -- "Api"                      --# return output to a programming interface
      },
    },
  },
  { -- need telescope
    'Zeioth/compiler.nvim',
    cond = false,
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    dependencies = { 'stevearc/overseer.nvim' },
    opts = {},
  },
  {
    'stevearc/overseer.nvim',
    cond = false,
    commit = '68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0',
    cmd = { 'CompilerOpen', 'CompilerToggleResults', 'CompilerRedo' },
    opts = {
      task_list = {
        direction = 'bottom',
        min_height = 25,
        max_height = 25,
        default_detail = 1,
      },
    },
  },
}
