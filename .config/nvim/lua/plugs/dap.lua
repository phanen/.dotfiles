return {
  {
    'mfussenegger/nvim-dap',
    cond = false,
    keys = {
      {
        '+dL',
        function() require('dap').set_breakpoint(nil, nil, fn.input 'log: ') end,
      },
      { '+db', function() require('dap').toggle_breakpoint() end, desc = 'dap: break' },
      { '+dB', function() require('dap').set_breakpoint(fn.input 'bc: ') end },
      { '+dc', function() require('dap').continue() end },
      { '+duc', function() require('dapui').close() end },
      { '+dut', function() require('dapui').toggle() end },
      { '+dt', function() require('dap').repl.toggle() end },
      { '+de', function() require('dap').step_out() end },
      { '+di', function() require('dap').step_into() end },
      { '+do', function() require('dap').step_over() end },
      { '+dl', function() require('dap').run_last() end },
    },
    config = function()
      local dap = require 'dap' -- NOTE: must be loaded before the signs can be tweaked
      local ui_ok, dapui = pcall(require, 'dapui')

      -- DON'T automatically stop at exceptions
      -- dap.defaults.fallback.exception_breakpoints = {}
      if not ui_ok then return end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end

      dap.adapters.cppdbg = {
        id = 'cppdbg',
        type = 'executable',
        command = '/home/phan/.local/share/nvim/mason/bin/OpenDebugAD7',
      }

      -- lldb from aur has lldb-vscode
      dap.adapters.lldb = {
        type = 'executable',
        command = '/usr/bin/lldb-vscode',
        name = 'lldb',
        args = { '--port', '${port}' },
      }

      dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
          command = '/home/phan/.local/share/nvim/mason/bin/codelldb',
          args = { '--port', '${port}' },

          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }

      dap.adapters.codelldb_manually = {
        type = 'server',
        host = '127.0.0.1',
        port = 13000, -- 💀 Use the port printed out or specified with `--port`
      }

      dap.configurations.cpp = {
        {
          name = 'cppdbg launch',
          type = 'cppdbg',
          request = 'launch',
          program = function() return fn.input('Path to executable: ', fn.getcwd() .. '/', 'file') end,
          cwd = '${workspaceFolder}',
          stopAtEntry = true,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'attach to gdbserver :1234',
          type = 'cppdbg',
          request = 'launch',
          MIMode = 'gdb',
          miDebuggerServerAddress = 'localhost:1234',
          miDebuggerPath = '/usr/bin/gdb',
          cwd = '${workspaceFolder}',
          program = function() return fn.input('Path to executable: ', fn.getcwd() .. '/a.out') end,
        },
        {
          name = 'codelldb launch',
          type = 'codelldb',
          request = 'launch',
          program = function() return fn.input('Path to executable: ', fn.getcwd() .. '/a.out') end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          -- args = {},
          -- runInTerminal = true,
        },
        {
          name = 'manual codelldb launch',
          type = 'codelldb',
          request = 'launch',
          program = function() return fn.input('Path to executable: ', fn.getcwd() .. '/a.out') end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          -- args = {},
          -- runInTerminal = true,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
    end,

    dependencies = {
      {
        {
          'rcarriga/nvim-dap-ui',
          opts = {
            windows = { indent = 2 },
            layouts = {
              {
                elements = {
                  { id = 'scopes', size = 0.25 },
                  { id = 'breakpoints', size = 0.25 },
                  { id = 'stacks', size = 0.25 },
                  { id = 'watches', size = 0.25 },
                },
                position = 'left',
                size = 20,
              },
              { elements = { { id = 'repl', size = 0.9 } }, position = 'bottom', size = 10 },
            },
          },
        },
        { 'theHamsta/nvim-dap-virtual-text', opts = { all_frames = true } },
      },
    },
  },
  {
    'jayp0521/mason-nvim-dap.nvim',
    cond = false,
    opts = {
      automatic_installation = true,
      ensure_installed = { 'codelldb' },
    },
  },
  {
    -- TODO: 或许只需要 snippet 的类似物, print 的内容我自己提供
    'andrewferrier/debugprint.nvim',
    cond = true,
    -- stylua: ignore
    keys = {
      { '<c-h>', function() return require('debugprint').debugprint() end,                   expr = true },
      { '+dp',   function() return require('debugprint').debugprint() end,                   expr = true },
      { '+dv',   function() return require('debugprint').debugprint { variable = true } end, expr = true },
      { '+do',   function() return require('debugprint').debugprint { motion = true } end,   expr = true },
      { '+da',   function() return require('debugprint').deleteprints() end,                 expr = true, mode = { 'n', 'x' } },
    },
    opts = { create_keymaps = false },
  },
  -- {
  --   'mfussenegger/nvim-dap',
  --   cmd = {
  --     'DapContinue',
  --     'DapLoadLaunchJSON',
  --     'DapRestartFrame',
  --     'DapSetLogLevel',
  --     'DapShowLog',
  --     'DapToggleBreakPoint',
  --   },
  --   keys = { '<F5>', '<F8>', '<F9>', '<F21>', '<F45>' },
  --   dependencies = {
  --     'rcarriga/cmp-dap',
  --     'rcarriga/nvim-dap-ui',
  --   },
  --   config = function() require('configs.nvim-dap') end,
  -- },
  {
    'jbyuki/one-small-step-for-vimkind',
    cmd = 'DapOSVLaunchServer',
    dependencies = 'mfussenegger/nvim-dap',
    config = function() require('configs.one-small-step-for-vimkind') end,
  },
  {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function() require('configs.nvim-dap-ui') end,
  },
}
