local fn = vim.fn

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<localleader>dL",
        function() require("dap").set_breakpoint(nil, nil, fn.input "Log point message: ") end,
        desc = "dap: log breakpoint",
      },
      {
        "<localleader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "dap: toggle breakpoint",
      },
      {
        "<localleader>dB",
        function() require("dap").set_breakpoint(fn.input "Breakpoint condition: ") end,
        desc = "dap: set conditional breakpoint",
      },
      {
        "<localleader>dc",
        function() require("dap").continue() end,
        desc = "dap: continue or start debugging",
      },
      {
        "<localleader>duc",
        function() require("dapui").close() end,
        desc = "dap ui: close",
      },
      {
        "<localleader>dut",
        function() require("dapui").toggle() end,
        desc = "dap ui: toggle",
      },
      { "<localleader>dt", function() require("dap").repl.toggle() end, desc = "dap: toggle repl" },
      { "<localleader>de", function() require("dap").step_out() end, desc = "dap: step out" },
      { "<localleader>di", function() require("dap").step_into() end, desc = "dap: step into" },
      { "<localleader>do", function() require("dap").step_over() end, desc = "dap: step over" },
      { "<localleader>dl", function() require("dap").run_last() end, desc = "dap REPL: run last" },
    },
    config = function()
      local dap = require "dap" -- NOTE: must be loaded before the signs can be tweaked
      local ui_ok, dapui = pcall(require, "dapui")

      -- DON'T automatically stop at exceptions
      -- dap.defaults.fallback.exception_breakpoints = {}
      if not ui_ok then return end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "/home/phanium/.local/share/nvim/mason/bin/OpenDebugAD7",
      }

      -- lldb from aur has lldb-vscode
      dap.adapters.lldb = {
        type = "executable",
        command = "/usr/bin/lldb-vscode",
        name = "lldb",
        args = { "--port", "${port}" },
      }

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "/home/phanium/.local/share/nvim/mason/bin/codelldb",
          args = { "--port", "${port}" },

          -- On windows you may have to uncomment this:
          -- detached = false,
        },
      }

      dap.adapters.codelldb_manually = {
        type = "server",
        host = "127.0.0.1",
        port = 13000, -- 💀 Use the port printed out or specified with `--port`
      }

      dap.configurations.cpp = {
        {
          name = "cppdbg launch",
          type = "cppdbg",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
          cwd = "${workspaceFolder}",
          stopAtEntry = true,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },

        {
          name = "attach to gdbserver :1234",
          type = "cppdbg",
          request = "launch",
          MIMode = "gdb",
          miDebuggerServerAddress = "localhost:1234",
          miDebuggerPath = "/usr/bin/gdb",
          cwd = "${workspaceFolder}",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out") end,
        },

        {
          name = "codelldb launch",
          type = "codelldb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out") end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          -- args = {},
          -- runInTerminal = true,
        },

        {
          name = "manual codelldb launch",
          type = "codelldb",
          request = "launch",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/a.out") end,
          cwd = "${workspaceFolder}",
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
          "rcarriga/nvim-dap-ui",
          opts = {
            windows = { indent = 2 },
            layouts = {
              {
                elements = {
                  { id = "scopes", size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks", size = 0.25 },
                  { id = "watches", size = 0.25 },
                },
                position = "left",
                size = 20,
              },
              { elements = { { id = "repl", size = 0.9 } }, position = "bottom", size = 10 },
            },
          },
        },
        { "theHamsta/nvim-dap-virtual-text", opts = { all_frames = true } },
      },
    },
  },

  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
  },

  {
    "jayp0521/mason-nvim-dap.nvim",
    cond = false,
    opts = {
      automatic_installation = true,
      ensure_installed = { "codelldb" },
    },
  },

  {
    "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
    config = function()
      require("toggle_lsp_diagnostics").init()
      -- require('toggle_lsp_diagnostics').init(vim.diagnostic.config())
    end,
    keys = {
      -- { "<leader>tlu", mode = { "n" }, "<Plug>(toggle-lsp-diag-underline)" },
      -- { "<leader>tls", mode = { "n" }, "<Plug>(toggle-lsp-diag-signs)" },
      -- { "<leader>tlv", mode = { "n" }, "<Plug>(toggle-lsp-diag-vtext)" },
      -- { "<leader>tlp", mode = { "n" }, "<Plug>(toggle-lsp-diag-update_in_insert)" },
      -- { "<leader>tld", mode = { "n" }, "<Plug>(toggle-lsp-diag)" },
      -- { "<leader>tldd", mode = { "n" }, "<Plug>(toggle-lsp-diag-default)" },
      { "<leader>tf", mode = { "n" }, "<Plug>(toggle-lsp-diag-off)" },
      { "<leader>to", mode = { "n" }, "<Plug>(toggle-lsp-diag-on)" },
    },
  },

  {
    "andrewferrier/debugprint.nvim",
    opts = { create_keymaps = false },
    keys = {
      {
        "<leader>dp",
        function() return require("debugprint").debugprint { variable = true } end,
        desc = "debugprint: cursor",
        expr = true,
      },
      {
        "<leader>do",
        function() return require("debugprint").debugprint { motion = true } end,
        desc = "debugprint: operator",
        expr = true,
      },
      { "<leader>dc", "<Cmd>DeleteDebugPrints<CR>", desc = "debugprint: clear all" },
    },
  },
}
