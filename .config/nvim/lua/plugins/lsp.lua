return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = { poll_rate = 2, override_vim_notify = false },
      integration = { ["nvim-tree"] = { enable = false } },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "Filetype",
    dependencies = {
      -- NOTE: useful in random plugin dir
      { "folke/neodev.nvim", ft = "lua", config = true },
      { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason", config = true },
      { "neovim/nvim-lspconfig", cmd = { "LspInfo", "LspInstall", "LspUninstall" } },
    },
    config = function()
      local lspconfig = require "lspconfig"
      local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok and cmp_nvim_lsp.default_capabilities() or nil
      require("mason-lspconfig").setup {
        handlers = {
          function(server) lspconfig[server].setup { capabilities = capabilities } end,
          lua_ls = function()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  hint = { enable = true, setType = true },
                  completion = { callSnippet = "Replace", postfix = ".", showWord = "Disable", workspaceWord = false },
                  format = { defaultConfig = { call_arg_parentheses = "remove_table_only", add_comma = "comma" } },
                  runtime = { version = "LuaJIT" },
                },
              },
            }
          end,
          clangd = function()
            lspconfig.clangd.setup {
              capabilities = capabilities,
              cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
              root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
            }
          end,
        },
      }
    end,
  },
}
