return {
  cmd = { 'lua-language-server' },
  -- cmd = { '/home/phan/b/emmylua-analyzer-rust/target/debug/emmylua_ls' },
  -- cmd = { '/home/phan/b/lua-language-server/bin/lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json',
    '.luarc.jsonc',
    '.luacheckrc',
    '.stylua.toml',
    'stylua.toml',
    'selene.toml',
    'selene.yml',
  },
  -- Note this is ignored if the project has a .luarc.json
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
        -- postfix = '.', -- no string.method now
        showWord = 'Disable',
        workspaceWord = false,
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/busted/library',
          '${3rd}/luv/library',
        },
      },
      runtime = { version = 'LuaJIT' },
    },
  },
  on_attach = function(...) return u.misc.auto_lua_require(...) end,
}
