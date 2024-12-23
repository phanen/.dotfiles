local Lsp = {}

---@autocmd
Lsp.on = function(_)
  local n = map[_.buf].n -- cannot use `0` here (current focused buf differ from LspAttach event buf)
  n[' rn'] = function() lsp.buf.rename() end
  n['gd'] = function() u.pick.lsp_definitions() end
  n['gh'] = function() u.pick.lsp_code_actions() end
  n.nowait['gr'] = function() u.pick.lsp_references() end -- note: nowait only apply to before mappings

  if true then return end
  local client = assert(lsp.get_client_by_id(_.data.client_id))
  if client:supports_method('textDocument/codeLens') then
    lsp.codelens.refresh { bufnr = _.buf }
    local _f = u.lodash.debounce(200, function(_) lsp.codelens.refresh { bufnr = _.buf } end)
    u.aug.lsp_codelens = {
      { 'BufEnter', 'CursorHold', 'InsertLeave' },
      { callback = _f },
    }
  end
end

---@autocmd
Lsp.setup = function(_)
  u.aug.lsp_attach = { 'LspAttach', function(_) u.lsp.on(_) end }

  if vim.bo[_.buf].ft == 'bigfile' then return end
  local cap = pcall(require, 'cmp_nvim_lsp')
  if cap then lsp.config('*', { capablities = cap }) end

  -- ensure mason path is prepended to PATH
  local pylance = {
    (true and fn.executable('delance-langserver') == 1) and 'delance-langserver'
      or 'pyright-langserver',
    '--stdio',
  }

  -- TODO: on_clangd.. on_lua_ls...
  -- e.g. lspconfig command feature, e.g. ClangdSwitchSourceHeader
  -- https://github.com/neovim/neovim/pull/31031
  lsp.config('clangd', {
    cmd = { 'clangd', '--clang-tidy', '--background-index', '--offset-encoding=utf-8' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { '.clangd', 'compile_commands.json' },
  })

  lsp.enable {
    -- 'clangd',
    'luals',
  }

  local l = require('lspconfig')

  l.clangd.setup {}

  l.pyright.setup { cmd = pylance } -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md

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

  l.ts_ls.setup {}

  l.volar.setup {
    on_attach = function(client, _) client.server_capabilities.documentFormattingProvider = false end,
  }
  l.fish_lsp.setup {}

  l.yamlls.setup {
    settings = {
      -- yaml = {
      --   schemaStore = { enable = false, url = '' },
      --   schemas = require('schemastore').yaml.schemas(),
      -- },
    },
  }

  l.vimls.setup {}

  l.rust_analyzer.setup {}

  l.dartls.setup {}
  vim.diagnostic.config {
    -- update_in_insert = true,
    float = { border = 'none' },
  }

  -- lsp folding
  if false and lsp._folding_range then
    vim.opt_local.fillchars = {
      eob = ' ',
      diff = '╱',
      foldopen = '',
      foldclose = '',
      foldsep = '▕',
    }
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'
    vim.wo.foldtext = 'v:lua.vim.lsp.foldtext()'
    vim.wo.foldcolumn = '1'
    api.nvim_create_autocmd('LspNotify', {
      callback = function(args)
        if args.data.method == 'textDocument/didOpen' then
          lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
        end
      end,
    })
  end

  if true then return end
  -- https://github.com/lewis6991/dotfiles/blob/main/config%2Fnvim%2Flua%2Flewis6991%2Flsp.lua
  local method = 'textDocument/documentHighlight'
  local f = function(args)
    -- if move_out_visual then
    lsp.buf.clear_references()
    -- end
    local bufnr = args.buf --- @type integer
    local win = api.nvim_get_current_win()
    for _, client in ipairs(lsp.get_clients { bufnr = bufnr, method = method }) do
      local enc = client.offset_encoding
      local param = lsp.util.make_position_params(0, enc)
      client:request(method, param, function(_, result, ctx)
        if not result or win ~= api.nvim_get_current_win() then return end
        lsp.util.buf_highlight_references(ctx.bufnr, result, client.offset_encoding)
      end, bufnr)
    end
  end
  u.aug.lsp_document_highlight = {
    { 'FocusGained', 'WinEnter', 'BufEnter', 'CursorMoved' },
    { callback = u.lodash.debounce(200, f) },
    { 'FocusLost', 'WinLeave', 'BufLeave' },
    { callback = lsp.buf.clear_references },
  }
end

return Lsp
