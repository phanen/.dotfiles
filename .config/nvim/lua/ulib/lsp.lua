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
    on_attach = function(client, bufnr)
      --- @param x string
      --- @return string?
      local function match_require(x)
        -- WIP: match u.xx?
        return x:match('require')
          and (
            x:match("require%s*%(%s*'([^.']+).*'%)")
            or x:match('require%s*%(%s*"([^."]+).*"%)')
            or x:match("require%s*'([^.']+).*'%)")
            or x:match('require%s*"([^."]+).*"%)')
          )
      end

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if uv.fs_stat(path .. '/.luarc.json') or uv.fs_stat(path .. '/.luarc.jsonc') then
          -- Updates to settings are igored if a .luarc.json is present
          return
        end

        -- local fd = uv.fs_open(root_dir .. '/.luarc.json', 'r', 438)
        -- local luarc = vim.json.decode(assert(vim.uv.fs_read(fd, vim.uv.fs_fstat(fd).size)))
        -- if not (luarc.workspace and luarc.workspace.library) then return end
      end

      client.settings = u.merge({ Lua = { workspace = { library = {} } } }, client.settings)

      --- @param first? integer
      --- @param last? integer
      local function on_lines(first, last)
        local do_change = false

        local lines = api.nvim_buf_get_lines(bufnr, first or 0, last or -1, false)
        for _, line in ipairs(lines) do
          local m = match_require(line)
          if m then
            for _, mod in ipairs(vim.loader.find(m, { patterns = { '', '.lua' } })) do
              local lib = fs.dirname(mod.modpath)
              local libs = client.settings.Lua.workspace.library
              if not vim.tbl_contains(libs, lib) then
                libs[#libs + 1] = lib
                do_change = true
              end
            end
          end
        end

        if do_change then
          client.notify('workspace/didChangeConfiguration', { settings = client.settings })
        end
      end

      api.nvim_buf_attach(bufnr, false, {
        on_lines = function(_, _, _, first, _, last) on_lines(first, last) end,
        on_reload = function() on_lines() end,
      })
      on_lines()
    end,
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
