-- FIXME(upstream): trigger only once (other than once for each event)

-- ftplugin, but for common part
autocmd('Filetype', {
  pattern = { 'help', 'man' },
  callback = function(ev)
    if vim.bo.bt ~= '' then
      map.n('u', '<c-u>', { buffer = ev.buf })
      map.n('d', '<c-d>', { buffer = ev.buf })
    end
  end,
})

augroup('YankHighlight', {
  'TextYankPost',
  {
    desc = 'Highlight the selection on yank',
    callback = function()
      -- https://github.com/ibhagwan/smartyank.nvim
      -- since there's no way to hook yank action(e.g. TextYankPre), "_d is always needed
      -- usually "_d or usually d ???

      vim.highlight.on_yank { higroup = 'Visual', timeout = 100 }
      -- require('vim.ui.clipboard.osc52').copy('+')({ fn.getreg('"') })
      -- require('vim.ui.clipboard.osc52').copy('*')
    end,
  },
})

-- https://github.com/jeffkreeftmeijer/vim-numbertoggle
augroup('NumberToggle', {
  { 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter', 'CmdlineEnter' },
  { command = [[if &nu && mode() != 'i' | set rnu | endif]] },
}, {
  { 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave', 'CmdlineLeave' },
  { command = [[if &nu | set nornu | endif]] },
})

-- create directories when needed
augroup('AutoMkdir', {
  'BufWritePre',
  {
    callback = function(ev)
      local file = uv.fs_realpath(ev.match) or ev.match
      fn.mkdir(fn.fnamemodify(file, ':p:h'), 'p')
      local backup = fn.fnamemodify(file, ':p:~:h')
      backup = (backup:gsub('[/\\]', '%%'))
      vim.go.backupext = backup
    end,
  },
})

-- auto reload buffer (external write)
augroup('AutoReLoadBuffer', {
  { 'FocusGained', 'BufEnter', 'CursorHold' },
  { command = [[if getcmdwintype() == '' | checktime | endif]] },
})

-- auto adjust window size
augroup('AutoResizeWin', {
  'VimResized',
  {
    callback = function()
      -- TODO: update some options (e.g. scrolloff)
      if vim.o.columns < 100 then
        -- if openned
        -- vim.cmd.NvimTreeClose()
        -- vim.cmd.AerialClose()
        vim.cmd.wincmd('|')
      else
        vim.cmd.wincmd('=')
      end
    end,
  },
})

-- augroup('KeepWinRatio', {
--   { 'VimResized', 'TabEnter' },
--   {
--     desc = 'Keep window ratio after resizing nvim',
--     callback = function()
--       vim.cmd.wincmd('=')
--       u.win.restratio(api.nvim_tabpage_list_wins(0))
--     end,
--   },
-- }, {
--   { 'TermOpen', 'WinResized', 'WinNew' },
--   {
--     desc = 'Record window ratio',
--     callback = function()
--       -- Don't record ratio if window resizing is caused by vim resizing
--       -- (changes in &lines or &columns)
--       local lines, columns = vim.go.lines, vim.go.columns
--       local _lines, _columns = vim.g._lines, vim.g._columns
--       if _lines and lines ~= _lines or _columns and columns ~= _columns then
--         vim.g._lines = lines
--         vim.g._columns = columns
--         return
--       end
--       if true then return end
--       u.win.saveratio(vim.v.event.windows)
--     end,
--   },
-- })

augroup('LazyPatch', {
  'User',
  {
    pattern = { 'LazyInstall*', 'LazyUpdate*', 'LazySync*', 'LazyRestore*' },
    callback = function(ev)
      g._lz_syncing = g._lz_syncing or ev.match == 'LazySyncPre'
      if g._lz_syncing and not ev.match:find('^LazySync') then return end
      if ev.match == 'LazySync' then g._lz_syncing = nil end
      local should_patch = not ev.match:find('Pre$')
      u.lazy.lazy_patch(should_patch)
      u.lazy.lazy_cache_docs()
    end,
  },
})

augroup('BigFileSettings', {
  'BufReadPre',
  {
    desc = 'Set settings for large files',
    callback = function(ev)
      vim.b.bigfile = false
      local stat = uv.fs_stat(ev.match)
      if stat and stat.size > 524288 then
        vim.b.bigfile = true
        vim.opt_local.spell = false
        vim.opt_local.swapfile = false
        vim.opt_local.undofile = false
        vim.opt_local.breakindent = false
        vim.opt_local.colorcolumn = ''
        vim.opt_local.statuscolumn = ''
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.winbar = ''
        vim.opt_local.syntax = ''
        autocmd('BufReadPost', {
          once = true,
          buffer = ev.buf,
          callback = function()
            vim.opt_local.syntax = ''
            return true
          end,
        })
      end
    end,
  },
})

-- Workaround for nvim treating whole Chinese sentence as a single word
-- Ideally something like https://github.com/neovim/neovim/pull/14029
-- will be merged to nvim, also see
-- https://github.com/neovim/neovim/issues/13967
-- augroup('CJKFileSettings', {
--   'BufEnter',
--   {
--     desc = 'Settings for CJK files',
--     callback = function(ev)
--       local lnum_nonblank = math.max(0, fn.nextnonblank(1) - 1)
--       local lines = api.nvim_buf_get_lines(ev.buf, lnum_nonblank, lnum_nonblank + 64, false)
--       for _, line in ipairs(lines) do
--         if line:match('[\128-\255]') then
--           vim.opt_local.linebreak = false
--           return
--         end
--       end
--     end,
--   },
-- })

-- auto save
-- TODO: support debounce_delay?
augroup('Autosave', {
  { 'BufLeave', 'WinLeave', 'FocusLost', 'InsertLeave', 'TextChanged' },
  {
    nested = true,
    desc = 'Autosave on focus change',
    callback = function(ev)
      if
        vim.bo[ev.buf].bt == ''
        and vim.bo[ev.buf].ft ~= ''
        and (vim.uv.fs_stat(ev.file) or {}).type == 'file'
      then
        vim.cmd.update { mods = { emsg_silent = true } }
      end
    end,
  },
})

-- augroup('WinCloseJmp', {
--   'WinClosed',
--   {
--     nested = true,
--     desc = 'Jump to last accessed window on closing the current one',
--     command = "if expand('<amatch>') == win_getid() | wincmd p | endif",
--   },
-- })

augroup('LastPosJump', {
  'BufReadPost',
  { -- NOTE: if `nvim +{num}`?
    command = [[call lastplace#jump()]],
    --  command = [[silent! normal! g`"zv']] ,
    -- function() vim.api.nvim_exec2('silent! normal! g`"zv', { output = false }) end
  },
})

augroup('AutoCwd', {
  {
    'BufWinEnter',
    'FileChangedShellPost',
  },
  {
    pattern = '*',
    desc = 'Automatically change local current directory',
    callback = function(ev)
      if ev.file == '' or vim.bo[ev.buf].bt ~= '' then return end
      local buf = ev.buf
      local win = api.nvim_get_current_win()
      vim.schedule(function()
        if
          not api.nvim_buf_is_valid(buf)
          or not api.nvim_win_is_valid(win)
          or not api.nvim_win_get_buf(win) == buf
        then
          return
        end
        api.nvim_win_call(win, function()
          local current_dir = fn.getcwd(0)
          local target_dir = u.fs.proj_dir(ev.file) or vim.fs.dirname(ev.file)
          local stat = target_dir and uv.fs_stat(target_dir)
          -- note: DirChanged autocmds may update winbar unexpectedly
          if stat and stat.type == 'directory' and current_dir ~= target_dir then
            pcall(vim.cmd.lcd, target_dir)
          end
        end)
      end)
    end,
  },
})

augroup('PromptBufKeymaps', {
  'BufEnter',
  {
    desc = 'Undo automatic <C-w> remap in prompt buffers',
    callback = function(ev)
      if vim.bo[ev.buf].buftype == 'prompt' then
        vim.keymap.set('i', '<C-w>', '<C-S-W>', { buffer = ev.buf })
      end
    end,
  },
})

augroup('QuickFixAutoOpen', {
  'QuickFixCmdPost',
  {
    desc = 'Open quickfix window if there are results',
    callback = function(ev)
      if #fn.getqflist() > 1 then
        vim.schedule(vim.cmd[ev.match:find('^l') and 'lwindow' or 'cwindow'])
      end
    end,
  },
})

-- show cursor line and cursor column only in current window
augroup('AutoHlCursorLine', {
  'WinEnter',
  {
    desc = 'Show cursorline and cursorcolumn in current window',
    callback = function()
      if vim.w._cul and not vim.wo.cul then
        vim.wo.cul = true
        vim.w._cul = nil
      end
      if vim.w._cuc and not vim.wo.cuc then
        vim.wo.cuc = true
        vim.w._cuc = nil
      end
      local prev_win = fn.win_getid(fn.winnr('#'))
      if prev_win ~= 0 then
        local w = vim.w[prev_win]
        local wo = vim.wo[prev_win]
        w._cul = wo.cul
        w._cuc = wo.cuc
        wo.cul = false
        wo.cuc = false
      end
    end,
  },
})

augroup('FixCmdLineIskeyword', {
  'CmdLineEnter',
  {
    desc = 'Have consistent &iskeyword and &lisp in Ex command-line mode',
    pattern = '[^/?]',
    callback = function(ev)
      -- Don't set &iskeyword and &lisp settings in search command-line
      -- ('/' and '?'), if we are searching in a lisp file, we want to
      -- have the same behavior as in insert mode
      vim.g._isk_lisp_buf = ev.buf
      vim.g._isk_save = vim.bo[ev.buf].isk
      vim.g._lisp_save = vim.bo[ev.buf].lisp
      vim.cmd.setlocal('isk&')
      vim.cmd.setlocal('lisp&')
    end,
  },
}, {
  'CmdLineLeave',
  {
    desc = 'Restore &iskeyword after leaving command-line mode',
    pattern = '[^/?]',
    callback = function()
      if
        vim.g._isk_lisp_buf
        and api.nvim_buf_is_valid(vim.g._isk_lisp_buf)
        and vim.g._isk_save ~= vim.b[vim.g._isk_lisp_buf].isk
      then
        vim.bo[vim.g._isk_lisp_buf].isk = vim.g._isk_save
        vim.bo[vim.g._isk_lisp_buf].lisp = vim.g._lisp_save
        vim.g._isk_save = nil
        vim.g._lisp_save = nil
        vim.g._isk_lisp_buf = nil
      end
    end,
  },
})

augroup('SpecialBufHl', {
  { 'BufWinEnter', 'BufNew', 'FileType', 'TermOpen' },
  {
    desc = 'Set background color for special buffers',
    callback = function(ev)
      if vim.bo[ev.buf].bt == '' then return end
      -- Current window isn't necessarily the window of the buffer that
      -- triggered the event, use `bufwinid()` to get the first window of
      -- the triggering buffer. We can also use `win_findbuf()` to get all
      -- windows that display the triggering buffer, but it is slower and using
      -- `bufwinid()` is enough for our purpose.
      local winid = fn.bufwinid(ev.buf)
      if winid == -1 then return end
      api.nvim_win_call(winid, function()
        local wintype = fn.win_gettype()
        if wintype == 'popup' or wintype == 'autocmd' then return end
        vim.opt_local.winhl:append({
          Normal = 'NormalSpecial',
          EndOfBuffer = 'NormalSpecial',
        })
      end)
    end,
  },
}, {
  { 'UIEnter', 'ColorScheme', 'OptionSet' },
  {
    desc = 'Set special buffer normal hl',
    callback = function(ev)
      if ev.event == 'OptionSet' and ev.match ~= 'background' then return end
      if true then return end
      local hl = u.hl
      local blended = hl.blend('Normal', 'CursorLine')
      hl.set_default(0, 'NormalSpecial', blended)
    end,
  },
})

-- FIXME: handle fugitive buffer
augroup('DeleteNoName', {
  'BufHidden',
  {
    desc = 'Delete [No Name] buffers',
    callback = function(ev)
      if ev.file == '' and vim.bo[ev.buf].buftype == '' and not vim.bo[ev.buf].modified then
        -- FIXME: no ft? esc
        vim.schedule(function() pcall(api.nvim_buf_delete, ev.buf, {}) end)
      end
    end,
  },
})

-- `q:`
autocmd('CmdwinEnter', {
  desc = 'cmdwin enter',
  pattern = '*',
  callback = function(ev)
    -- FIXME(upstream): set in source (but not work)
    -- tbh, cmdwin is really useless...
    vim.bo[ev.buf].ft = 'vim'
    vim.wo.signcolumn = 'no'
    vim.wo.foldcolumn = '0'
    map.n('<cr>', 'a<cr>', { buffer = ev.buf })
  end,
})

-- FIXME: when close diffview
augroup('ToggleWhenDiff', {
  'OptionSet',
  {
    desc = 'turn off inlayhint/diagnostics when diff option toggle',
    pattern = 'diff',
    callback = function(ev)
      if vim.v.option_new then
        local clients = lsp.get_clients {
          bufnr = ev.buf,
          method = lsp.protocol.Methods.textDocument_inlayHint,
        }
        if #clients > 0 and lsp.inlay_hint.is_enabled { bufnr = ev.buf } then
          lsp.inlay_hint.enable(false, { bufnr = ev.buf })
        end
        vim.diagnostic.config { signs = false }
      else
        local clients = lsp.get_clients {
          bufnr = ev.buf,
          method = lsp.protocol.Methods.textDocument_inlayHint,
        }
        vim.print(clients)
        if #clients > 0 and not lsp.inlay_hint.is_enabled { bufnr = ev.buf } then
          lsp.inlay_hint.enable(true, { bufnr = ev.buf })
        end
        vim.diagnostic.config { signs = true }
      end
    end,
  },
})
