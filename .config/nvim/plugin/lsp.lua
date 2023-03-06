local lsp_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<c-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local lsp_servers = {
  lua_ls = {},
  clangd = {},
  rust_analyzer = {},
  gopls = {},
  pyright = {},
  tsserver = {},
}

require('mason').setup()
local mlsp = require 'mason-lspconfig'

mlsp.setup {
  ensure_installed = vim.tbl_keys(lsp_servers),
}

mlsp.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = lsp_attach,
      settings = lsp_servers[server_name],
    }
  end,

  -- ['texlab'] = function ()
  --   require('lspconfig').texlab.setup({
  -- end
  --   })
  -- ['marksman'] = function()
  --   require('lspconfig').marksman.setup {
  --     on_attach = on_attach,
  --     capabilities = capabilities,
  --     cmd = { 'marksman', 'server' },
  --     filetypes = { 'markdown' },
  --     single_file_support = false,
  --     flags = {
  --       debounce_text_changes = 150
  --     }
  --   }
  -- end,
}

-- core API
-- LaunchMarksman = function()
--   local client_id = vim.lsp.start_client({cmd = {'marksman', 'server'}})
--   vim.lsp.buf_attach_client(0, client_id)
--   local client = vim.lsp.get_client_by_id(client_id)
-- end
--
-- vim.cmd([[
--   command! -range LaunchMarksman  execute 'lua LaunchMarksman()'
-- ]])

-- require('lspconfig').marksman.setup{
--   on_attach=on_attach
-- }

-- require('lspconfig').gopls.setup{
--   on_attach=on_attach,
-- }
--


-- debug
local dap = require("dap")
local dapui = require("dapui")

-- lldb from aur has lldb-vscode
dap.adapters.lldb = {
  type = "executable",
  command = '/usr/bin/lldb-vscode',
  name = "lldb",
  args = { "--port", "${port}" },
}

-- codelldb from mason
dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/home/phanium/.local/share/nvim/mason/bin/codelldb',
    args = { "--port", "${port}" },
  }
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'codelldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  },
}

dap.configurations.c = dap.configurations.cpp

vim.keymap.set("n", "<F5>", dap.step_into)
vim.keymap.set("n", "<F6>", dap.step_over)
vim.keymap.set("n", "<F7>", dap.step_out)
vim.keymap.set("n", "<F8>", dap.continue)

vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>bc",
  function() dap.set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end)

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

-- dap.listeners.before.event_terminated["dapui_config"] = function()
--   dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--   dapui.close()
-- end

-- use mason to find the path
local codelldb_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"
-- dap.adapters.rust = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)

require("nvim-dap-virtual-text").setup()

local rt = require('rust-tools')
local opts = {
  tools = {
    executor = require("rust-tools.executors").termopen,

    -- callback to execute once rust-analyzer is done initializing the workspace
    -- The callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
    on_initialized = nil,
    -- automatically call RustReloadWorkspace when writing to a Cargo.toml file.
    reload_workspace_from_cargo_toml = true,
    -- These apply to the default RustSetInlayHints command
    inlay_hints = {
      -- automatically set inlay hints (type hints)
      -- default: true
      auto = true,
      -- Only show inlay hints for the current line
      only_current_line = false,
      -- whether to show parameter hints with the inlay hints or not
      -- default: true
      show_parameter_hints = true,
      -- prefix for parameter hints
      -- default: "<-"
      parameter_hints_prefix = "<- ",
      -- prefix for all the other hints (type, chaining)
      -- default: "=>"
      other_hints_prefix = "=> ",
      -- whether to align to the length of the longest line in the file
      max_len_align = false,
      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,
      -- whether to align to the extreme right or not
      right_align = false,
      -- padding from the right if right_align is true
      right_align_padding = 7,
      -- The color of the hints
      highlight = "Comment",
    },

    -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    hover_actions = {
      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      },

      -- Maximal width of the hover window. Nil means no max.
      max_width = nil,

      -- Maximal height of the hover window. Nil means no max.
      max_height = nil,

      -- whether the hover action window gets automatically focused
      -- default: false
      auto_focus = false,
    },

    -- settings for showing the crate graph based on graphviz and the dot
    -- command
    crate_graph = {
      -- Backend used for displaying the graph
      -- see: https://graphviz.org/docs/outputs/
      -- default: x11
      backend = "x11",
      -- where to store the output, nil for no output stored (relative
      -- path from pwd)
      -- default: nil
      output = nil,
      -- true for all crates.io and external crates, false only the local
      -- crates
      -- default: true
      full = true,

      -- List of backends found on: https://graphviz.org/docs/outputs/
      -- Is used for input validation and autocompletion
      -- Last updated: 2021-08-26
      enabled_graphviz_backends = {
        "bmp",
        "cgimage",
        "canon",
        "dot",
        "gv",
        "xdot",
        "xdot1.2",
        "xdot1.4",
        "eps",
        "exr",
        "fig",
        "gd",
        "gd2",
        "gif",
        "gtk",
        "ico",
        "cmap",
        "ismap",
        "imap",
        "cmapx",
        "imap_np",
        "cmapx_np",
        "jpg",
        "jpeg",
        "jpe",
        "jp2",
        "json",
        "json0",
        "dot_json",
        "xdot_json",
        "pdf",
        "pic",
        "pct",
        "pict",
        "plain",
        "plain-ext",
        "png",
        "pov",
        "ps",
        "ps2",
        "psd",
        "sgi",
        "svg",
        "svgz",
        "tga",
        "tiff",
        "tif",
        "tk",
        "vml",
        "vmlz",
        "wbmp",
        "webp",
        "xlib",
        "x11",
      },
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    -- standalone file support
    -- setting it to false may improve startup time
    standalone = true,
    capabilities = capabilities,
    on_attach = function(_, bufnr)
      lsp_attach(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<leader>rh", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>ra", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  }, -- rust-analyzer options

  -- debugging stuff
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
  },
  -- dap = {
  --   adapter = {
  --     type = "executable",
  --     command = "lldb-vscode",
  --     name = "rt_lldb",
  --   },
  -- },
}

-- dap.adapters.codelldb = {
--   type = 'server',
--   port = "${port}",
--   executable = {
--     command = '/home/phanium/.local/share/nvim/mason/bin/codelldb',
--     args = { "--port", "${port}" },
--   }
-- }

dap.adapters.rt_lldb = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)

dap.configurations.rust = {
  {
    name = 'Launch',
    type = 'codelldb',
    -- type = 'rt_lldb', -- 疑似兼容性不好/功能不全
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  }
}

rt.setup(opts)
