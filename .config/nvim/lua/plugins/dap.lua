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
      { "<localleader>de", function() require("dap").step_out() end,    desc = "dap: step out" },
      { "<localleader>di", function() require("dap").step_into() end,   desc = "dap: step into" },
      { "<localleader>do", function() require("dap").step_over() end,   desc = "dap: step over" },
      { "<localleader>dl", function() require("dap").run_last() end,    desc = "dap REPL: run last" },
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
                  { id = "scopes",      size = 0.25 },
                  { id = "breakpoints", size = 0.25 },
                  { id = "stacks",      size = 0.25 },
                  { id = "watches",     size = 0.25 },
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

  { -- rust
    "simrat39/rust-tools.nvim",
    -- lazy = false,
    -- config = function()
    -- end,
  },
}

-- -- debug
-- vim.keymap.set("n", "<F5>", dap.step_into)
-- vim.keymap.set("n", "<F6>", dap.step_over)
-- vim.keymap.set("n", "<F7>", dap.step_out)
-- vim.keymap.set("n", "<F8>", dap.continue)
-- vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint)
-- vim.keymap.set("n", "<leader>bc",
--   function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end)
--
-- dapui.setup()
-- dap.listeners.after.event_initialized["dapui_config"] = function()
--   dapui.open()
-- end
--
-- -- dap.listeners.before.event_terminated["dapui_config"] = function()
-- --   dapui.close()
-- -- end
-- -- dap.listeners.before.event_exited["dapui_config"] = function()
-- --   dapui.close()
-- -- end
--
-- -- use mason to find the path
-- local codelldb_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
-- local codelldb_path = codelldb_root .. "adapter/codelldb"
-- local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
-- -- dap.adapters.rust = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
--
-- require("nvim-dap-virtual-text").setup()
--
-- local rt = require('rust-tools')
-- local opts = {
--   tools = {
--     executor = require("rust-tools.executors").termopen,
--
--     -- callback to execute once rust-analyzer is done initializing the workspace
--     -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
--     on_initialized = nil,
--     -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
--     reload_workspace_from_cargo_toml = true,
--     -- These apply to the default RustSetInlayHints command
--     inlay_hints = {
--       -- automatically set inlay hints (type hints)
--       -- default: true
--       auto = true,
--       -- Only show inlay hints for the current line
--       only_current_line = false,
--       -- whether to show parameter hints with the inlay hints or not
--       -- default: true
--       show_parameter_hints = true,
--       -- prefix for parameter hints
--       -- default: "<-"
--       parameter_hints_prefix = "<- ",
--       -- prefix for all the other hints (type, chaining)
--       -- default: "=>"
--       other_hints_prefix = "=> ",
--       -- whether to align to the length of the longest line in the file
--       max_len_align = false,
--       -- padding from the left if max_len_align is true
--       max_len_align_padding = 1,
--       -- whether to align to the extreme right or not
--       right_align = false,
--       -- padding from the right if right_align is true
--       right_align_padding = 7,
--       -- The color of the hints
--       highlight = "Comment",
--     },
--
--     -- options same as lsp hover / vim.lsp.util.open_floating_preview()
--     hover_actions = {
--       -- the border that is used for the hover window
--       -- see vim.api.nvim_open_win()
--       border = {
--         { "╭", "FloatBorder" },
--         { "─", "FloatBorder" },
--         { "╮", "FloatBorder" },
--         { "│", "FloatBorder" },
--         { "╯", "FloatBorder" },
--         { "─", "FloatBorder" },
--         { "╰", "FloatBorder" },
--         { "│", "FloatBorder" },
--       },
--
--       -- Maximal width of the hover window. Nil means no max.
--       max_width = nil,
--
--       -- Maximal height of the hover window. Nil means no max.
--       max_height = nil,
--
--       -- whether the hover action window gets automatically focused
--       -- default: false
--       auto_focus = false,
--     },
--
--     -- settings for showing the crate graph based on graphviz and the dot
--     -- command
--     crate_graph = {
--       -- Backend used for displaying the graph
--       -- see: https://graphviz.org/docs/outputs/
--       -- default: x11
--       backend = "x11",
--       -- where to store the output, nil for no output stored (relative
--       -- path from pwd)
--       -- default: nil
--       output = nil,
--       -- true for all crates.io and external crates, false only the local
--       -- crates
--       -- default: true
--       full = true,
--
--       -- List of backends found on: https://graphviz.org/docs/outputs/
--       -- Is used for input validation and autocompletion
--       -- Last updated: 2021-08-26
--       enabled_graphviz_backends = {
--         "bmp",
--         "cgimage",
--         "canon",
--         "dot",
--         "gv",
--         "xdot",
--         "xdot1.2",
--         "xdot1.4",
--         "eps",
--         "exr",
--         "fig",
--         "gd",
--         "gd2",
--         "gif",
--         "gtk",
--         "ico",
--         "cmap",
--         "ismap",
--         "imap",
--         "cmapx",
--         "imap_np",
--         "cmapx_np",
--         "jpg",
--         "jpeg",
--         "jpe",
--         "jp2",
--         "json",
--         "json0",
--         "dot_json",
--         "xdot_json",
--         "pdf",
--         "pic",
--         "pct",
--         "pict",
--         "plain",
--         "plain-ext",
--         "png",
--         "pov",
--         "ps",
--         "ps2",
--         "psd",
--         "sgi",
--         "svg",
--         "svgz",
--         "tga",
--         "tiff",
--         "tif",
--         "tk",
--         "vml",
--         "vmlz",
--         "wbmp",
--         "webp",
--         "xlib",
--         "x11",
--       },
--     },
--   },
--
--   -- all the opts to send to nvim-lspconfig
--   -- these override the defaults set by rust-tools.nvim
--   -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
--   server = {
--     -- standalone file support
--     -- setting it to false may improve startup time
--     standalone = true,
--     capabilities = capabilities,
--     on_attach = function(_, bufnr)
--       lsp_attach(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   }, -- rust-analyzer options
--
--   -- debugging stuff
--   dap = {
--     adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
--   },
--   -- dap = {
--   --   adapter = {
--   --     type = "executable",
--   --     command = "lldb-vscode",
--   --     name = "rt_lldb",
--   --   },
--   -- },
-- }
--
-- -- dap.adapters.codelldb = {
-- --   type = 'server',
-- --   port = "${port}",
-- --   executable = {
-- --     command = '/home/phanium/.local/share/nvim/mason/bin/codelldb',
-- --     args = { "--port", "${port}" },
-- --   }
-- -- }
--
-- dap.adapters.rt_lldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
--
-- dap.configurations.rust = {
--   {
--     name = 'Launch',
--     type = 'codelldb',
--     -- type = 'rt_lldb', -- 疑似兼容性不好/功能不全
--     request = 'launch',
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopOnEntry = false,
--     args = {},
--   }
-- }
--
-- rt.setup(opts)
