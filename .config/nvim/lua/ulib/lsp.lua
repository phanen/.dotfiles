local Lsp = {}

---@return lsp.ClientCapabilities
Lsp.make_capabilities = function()
  local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
  local lsp_cap = vim.lsp.protocol.make_client_capabilities()
  local cmp_cap = ok and cmp_nvim_lsp.default_capabilities()
  return u.merge(lsp_cap or {}, cmp_cap or {})
end
---Lsp.make_capabilities = vim.func._memoize(nil, Lsp.make_capabilities, true)

---@autocmd
Lsp.on = function(_)
  local n = map[0].n
  n[' rn'] = function() lsp.buf.rename() end
  n['gd'] = function() u.pick.lsp_definitions() end
  n['gh'] = function() u.pick.lsp_code_actions() end
  n.nowait['gr'] = function() u.pick.lsp_references() end -- note: nowait only apply to before mappings

  vim.diagnostic.config {
    -- update_in_insert = true,
    float = { border = 'none' },
  }

  -- https://github.com/lewis6991/dotfiles/blob/main/config%2Fnvim%2Flua%2Flewis6991%2Flsp.lua

  -- do -- textDocument/documentHighlight
  --   local f = function(args)
  --     -- if move_out_visual then
  --     lsp.buf.clear_references()
  --     -- end
  --     local bufnr = args.buf --- @type integer
  --     for _, client in ipairs(lsp.get_clients({ bufnr = bufnr })) do
  --       if client.supports_method('textDocument/documentHighlight', { bufnr = bufnr }) then
  --         local params = lsp.util.make_position_params()
  --         client.request('textDocument/documentHighlight', params, nil, bufnr)
  --       end
  --       -- FIXME: when there's multiple server...
  --       break
  --     end
  --   end
  --
  --   api.nvim_create_autocmd(
  --     -- { 'FocusGained', 'WinEnter', 'BufEnter', 'CursorMoved', 'CursorHold', 'CursorHoldI' },
  --     { 'FocusGained', 'WinEnter', 'BufEnter', 'CursorHold', 'CursorHoldI' },
  --     { callback = f }
  --     -- { callback = u.lodash.debounce(200, f) }
  --   )
  --
  --   api.nvim_create_autocmd(
  --     { 'FocusLost', 'WinLeave', 'BufLeave' },
  --     { callback = lsp.buf.clear_references }
  --   )
  -- end

  -- -- textDocument/codelens
  -- local client = assert(lsp.get_client_by_id(_.data.client_id))
  -- if client.supports_method('textDocument/codeLens') then
  --   lsp.codelens.refresh({ bufnr = _.buf })
  --   api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
  --     callback = function(_) lsp.codelens.refresh({ bufnr = _.buf }) end,
  --   })
  -- end
end

Lsp.setup = function()
  -- ensure mason path is prepended to PATH
  local l = require('lspconfig')
  l.lua_ls.setup {
    -- cmd = { vim.fs.normalize '~/b/lua-language-server/build/bin/lua-language-server' },
    -- on_attach = function(client, _) client.server_capabilities.semanticTokensProvider = nil end,
    settings = {
      Lua = {
        hint = { enable = true, setType = true },
        completion = {
          callSnippet = 'Replace',
          -- postfix = '.', -- no string.method now
          showWord = 'Disable',
          workspaceWord = false,
        },
        runtime = { version = 'LuaJIT' },
      },
    },
  }

  l.clangd.setup {
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
    },
  }

  l.pyright.setup {
    -- cmd = { "delance-langserver", "--stdio" },
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'openFilesOnly',
        },
      },
    },
  }

  l.gopls.setup {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  }

  l.volar.setup {
    on_attach = function(client, _) client.server_capabilities.documentFormattingProvider = false end,
  }
end

return Lsp
