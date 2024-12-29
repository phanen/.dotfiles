return {
  {
    'nvim-tree/nvim-tree.lua',
    cond = true,
    -- workaround for open dir
    lazy = not fn.argv()[1],
    event = 'CmdlineEnter',
    cmd = { 'NvimTreeFindFileToggle' },
    keys = { 'gf', { ' k', '<cmd>NvimTreeFindFileToggle<cr>' } },
    opts = {
      sync_root_with_cwd = true,
      actions = { change_dir = { enable = true, global = true } },
      select_prompts = false,
      view = {
        -- width = math.min(math.floor(vim.go.columns), 25),
        width = {
          min = function() return math.max(math.floor(vim.go.columns), 25) end,
          max = function() return math.min(math.floor(vim.go.columns), 35) end,
        },
        adaptive_size = true,
      },
      -- hijack_directories = { enable = false },
      on_attach = function(bufnr)
        local api = package.loaded['nvim-tree.api']
        api.config.mappings.default_on_attach(bufnr)
        local node_path_dir = function()
          local node = api.tree.get_node_under_cursor()
          if not node then return end
          if node.parent and node.type == 'file' then return node.parent.absolute_path end
          return node.absolute_path
        end
        local files = function() require('fzf-lua').files { cwd = node_path_dir() or uv.cwd() } end
        local grep = function()
          require('fzf-lua').live_grep_native { cwd = node_path_dir() or uv.cwd() }
        end
        local n = function(lhs, rhs) return map('n', lhs, rhs, { buffer = bufnr }) end
        n('h', api.node.navigate.parent)
        n('l', api.node.open.edit)
        n('o', api.tree.change_root_to_node)
        n('<c-f>', files)
        n('<c-e>', grep)
        n('gj', api.node.navigate.git.next)
        n('gk', api.node.navigate.git.prev)
      end,
    },
  },

  {
    'mikavilpas/yazi.nvim',
    keys = {
      { ' +', '<cmd>Yazi toggle<cr>', desc = 'Resume the last yazi session' },
      { ' cw', '<cmd>Yazi cwd<cr>' },
    },
    opts = {
      open_for_directories = false, -- hijack netrw for dir
      use_ya_for_events_reading = true,
      use_yazi_client_id_flag = true,
      keymaps = { show_help = '<f1>' },
    },
  },

  {
    'nvim-neo-tree/neo-tree.nvim',
    cond = false,
    keys = { { '<leader>k', '<cmd>Neotree action=focus reveal=true<cr>' } },
    branch = 'main',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    init = function()
      autocmd('BufEnter', {
        callback = function(args)
          local stats = uv.fs_stat(args.file)
          if not stats or stats.type ~= 'directory' then return end
          require 'neo-tree'
          return true
        end,
      })
    end,
    opts = {
      default_source = 'last',
      window = {
        mappings = {
          ['<space>'] = 'none',
          ['gl'] = 'open',
          ['h'] = 'parent_or_collapse',
          ['l'] = 'toggle_or_open',
          ['<a-l>'] = 'next_source',
          ['<a-h>'] = 'prev_source',
          ['gk'] = 'prev_git_modified',
          ['gj'] = 'next_git_modified',
          -- TODO: rename only basename
          -- [] = 'rename',
        },
      },
      commands = {
        open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          vim.ui.open(path)
        end,
        parent_or_collapse = function(state)
          local node = state.tree:get_node()
          if node.type == 'directory' and node:is_expanded() then
            if state.name == 'filesystem' then
              require('neo-tree.sources.filesystem.commands').toggle_node(state)
            else
              require('neo-tree.sources.common.commands').toggle_node(state)
            end
          else
            require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
          end
        end,
        toggle_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == 'directory' then
            if state.name == 'filesystem' then
              require('neo-tree.sources.filesystem.commands').toggle_node(state)
            else
              require('neo-tree.sources.common.commands').toggle_node(state)
            end
          elseif node.type == 'file' then
            require('neo-tree.sources.common.commands').open(state)
          end
        end,
      },
      filesystem = {
        group_empty_dirs = true,
        follow_current_file = { enabled = true },
        window = { mappings = { ['gj'] = 'prev_git_modified', ['gk'] = 'next_git_modified' } },
      },
    },
  },

  {
    'stevearc/oil.nvim',
    cond = false,
    cmd = 'Oil',
    keys = { { ' %', '<cmd>Oil<cr>' } },
    init = function() -- Load oil on startup only when editing a directory
      vim.g.loaded_fzf_file_explorer = 1
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      autocmd('BufWinEnter', {
        nested = true,
        callback = function(info)
          local path = info.file
          if path == '' then return end
          local stat = uv.fs_stat(path)
          if stat and stat.type == 'directory' then
            api.nvim_del_autocmd(info.id)
            require('oil')
            vim.cmd.edit({
              bang = true,
              mods = { keepjumps = true },
            })
            return true
          end
        end,
      })
    end,
    config = function()
      vim.g.loaded_fzf_file_explorer = 1
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local oil = require('oil')

      local preview_wins = {} ---@type table<integer, integer>
      local preview_bufs = {} ---@type table<integer, integer>
      local preview_max_fsize = 1000000
      local preview_debounce = 64 -- ms
      local preview_request_last_timestamp = 0

      ---Change window-local directory to `dir`
      ---@param dir string
      ---@return nil
      local function lcd(dir)
        local ok = pcall(vim.cmd.lcd, dir)
        if not ok then vim.notify('[oil.nvim] failed to cd to ' .. dir, vim.log.levels.WARN) end
      end

      ---Generate lines for preview window when preview is not available
      ---@param msg string
      ---@param height integer
      ---@param width integer
      ---@return string[]
      local function nopreview(msg, height, width)
        local lines = {}
        local fillchar = vim.opt_local.fillchars:get().diff or '-'
        local msglen = #msg + 4
        local padlen_l = math.max(0, math.floor((width - msglen) / 2))
        local padlen_r = math.max(0, width - msglen - padlen_l)
        local line_fill = fillchar:rep(width)
        local half_fill_l = fillchar:rep(padlen_l)
        local half_fill_r = fillchar:rep(padlen_r)
        local line_above = half_fill_l .. string.rep(' ', msglen) .. half_fill_r
        local line_below = line_above
        local line_msg = half_fill_l .. '  ' .. msg .. '  ' .. half_fill_r
        local half_height_u = math.max(0, math.floor((height - 3) / 2))
        local half_height_d = math.max(0, height - 3 - half_height_u)
        for _ = 1, half_height_u do
          table.insert(lines, line_fill)
        end
        table.insert(lines, line_above)
        table.insert(lines, line_msg)
        table.insert(lines, line_below)
        for _ = 1, half_height_d do
          table.insert(lines, line_fill)
        end
        return lines
      end

      ---End preview for oil window `win`
      ---Close preview window and delete preview buffer
      ---@param oil_win? integer oil window ID
      ---@return nil
      local function end_preview(oil_win)
        oil_win = oil_win or api.nvim_get_current_win()
        local preview_win = preview_wins[oil_win]
        local preview_buf = preview_bufs[oil_win]
        if
          preview_win
          and api.nvim_win_is_valid(preview_win)
          and fn.winbufnr(preview_win) == preview_buf
        then
          api.nvim_win_close(preview_win, true)
        end
        if preview_buf and api.nvim_win_is_valid(preview_buf) then
          api.nvim_win_close(preview_buf, true)
        end
        preview_wins[oil_win] = nil
        preview_bufs[oil_win] = nil
      end

      ---Preview file under cursor in a split
      ---@return nil
      local function preview()
        local entry = oil.get_cursor_entry()
        local fname = entry and entry.name
        local dir = oil.get_current_dir()
        if not dir or not fname then return end
        local fpath = vim.fs.joinpath(dir, fname)
        local stat = uv.fs_stat(fpath)
        if not stat or (stat.type ~= 'file' and stat.type ~= 'directory') then return end
        local oil_win = api.nvim_get_current_win()
        local preview_win = preview_wins[oil_win]
        local preview_buf = preview_bufs[oil_win]
        if
          not preview_win
          or not preview_buf
          or not api.nvim_win_is_valid(preview_win)
          or not api.nvim_buf_is_valid(preview_buf)
        then
          local oil_win_height = api.nvim_win_get_height(oil_win)
          local oil_win_width = api.nvim_win_get_width(oil_win)
          vim.cmd.new({
            mods = {
              vertical = oil_win_width > 6 * oil_win_height,
            },
          })
          preview_win = api.nvim_get_current_win()
          preview_buf = api.nvim_get_current_buf()
          preview_wins[oil_win] = preview_win
          preview_bufs[oil_win] = preview_buf
          vim.bo[preview_buf].swapfile = false
          vim.bo[preview_buf].buflisted = false
          vim.bo[preview_buf].buftype = 'nofile'
          vim.bo[preview_buf].bufhidden = 'wipe'
          vim.bo[preview_buf].filetype = 'oil_preview'
          vim.opt_local.spell = false
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = 'no'
          vim.opt_local.foldcolumn = '0'
          vim.opt_local.winbar = ''
          api.nvim_set_current_win(oil_win)
        end
        -- Set keymap for opening the file from preview buffer
        map.n('<CR>', function()
          vim.cmd.edit(fpath)
          end_preview(oil_win)
        end, { buffer = preview_buf })
        -- Preview buffer already contains contents of file to preview
        local preview_bufname = fn.bufname(preview_buf)
        local preview_bufnewname = 'oil_preview://' .. fpath
        if preview_bufname == preview_bufnewname then return end
        local preview_win_height = api.nvim_win_get_height(preview_win)
        local preview_win_width = api.nvim_win_get_width(preview_win)
        local add_syntax = false
        local lines = {}
        lines = stat.type == 'directory' and fn.systemlist('ls -lhA ' .. fn.shellescape(fpath))
          or stat.size == 0 and nopreview('Empty file', preview_win_height, preview_win_width)
          or stat.size > preview_max_fsize and nopreview(
            'File too large to preview',
            preview_win_height,
            preview_win_width
          )
          or not fn.system({ 'file', fpath }):match('text') and nopreview(
            'Binary file, no preview available',
            preview_win_height,
            preview_win_width
          )
          or (function()
              add_syntax = true
              return true
            end)()
            and vim
              .iter(io.lines(fpath))
              :map(function(line) return (line:gsub('\x0d$', '')) end)
              :totable()
        api.nvim_buf_set_lines(preview_buf, 0, -1, false, lines)
        api.nvim_buf_set_name(preview_buf, preview_bufnewname)
        -- If previewing a directory, change cwd to that directory
        -- so that we can `gf` to files in the preview buffer;
        -- else change cwd to the parent directory of the file in preview
        api.nvim_win_call(preview_win, function()
          local target_dir = stat.type == 'directory' and fpath or dir
          if not fn.getcwd(0) ~= target_dir then lcd(target_dir) end
        end)
        api.nvim_buf_call(preview_buf, function() vim.treesitter.stop(preview_buf) end)
        vim.bo[preview_buf].syntax = ''
        if not add_syntax then return end
        local ft = vim.filetype.match({
          buf = preview_buf,
          filename = fpath,
        })
        if ft and not pcall(vim.treesitter.start, preview_buf, ft) then
          vim.bo[preview_buf].syntax = ft
        end
      end

      local groupid_preview = ag('OilPreview', {})
      autocmd({ 'CursorMoved', 'WinScrolled' }, {
        desc = 'Update floating preview window when cursor moves or window scrolls.',
        group = groupid_preview,
        pattern = 'oil:///*',
        callback = function()
          local oil_win = api.nvim_get_current_win()
          local preview_win = preview_wins[oil_win]
          if not preview_win or not api.nvim_win_is_valid(preview_win) then
            end_preview()
            return
          end
          local current_request_timestamp = uv.now()
          preview_request_last_timestamp = current_request_timestamp
          vim.defer_fn(function()
            if preview_request_last_timestamp == current_request_timestamp then preview() end
          end, preview_debounce)
        end,
      })
      autocmd('BufEnter', {
        desc = 'Close preview window when leaving oil buffers.',
        group = groupid_preview,
        callback = function(info)
          if vim.bo[info.buf].filetype ~= 'oil' then end_preview() end
        end,
      })
      autocmd('WinClosed', {
        desc = 'Close preview window when closing oil windows.',
        group = groupid_preview,
        callback = function(info)
          local win = tonumber(info.match)
          if win and preview_wins[win] then end_preview(win) end
        end,
      })

      ---Toggle preview window
      ---@return nil
      local function toggle_preview()
        local oil_win = api.nvim_get_current_win()
        local preview_win = preview_wins[oil_win]
        if not preview_win or not api.nvim_win_is_valid(preview_win) then
          preview()
          return
        end
        end_preview()
      end

      local preview_mapping = {
        mode = { 'n', 'x' },
        desc = 'Toggle preview',
        callback = toggle_preview,
      }

      local permission_hlgroups = setmetatable({
        ['-'] = 'OilPermissionNone',
        ['r'] = 'OilPermissionRead',
        ['w'] = 'OilPermissionWrite',
        ['x'] = 'OilPermissionExecute',
      }, {
        __index = function() return 'OilDir' end,
      })

      local type_hlgroups = setmetatable({
        ['-'] = 'OilTypeFile',
        ['d'] = 'OilTypeDir',
        ['p'] = 'OilTypeFifo',
        ['l'] = 'OilTypeLink',
        ['s'] = 'OilTypeSocket',
      }, {
        __index = function() return 'OilTypeFile' end,
      })

      local border = vim.g.modern_ui and 'solid' or 'single'

      oil.setup({
        columns = {
          {
            'type',
            icons = {
              directory = 'd',
              fifo = 'p',
              file = '-',
              link = 'l',
              socket = 's',
            },
            highlight = function(type_str) return type_hlgroups[type_str] end,
          },
          {
            'permissions',
            highlight = function(permission_str)
              local hls = {}
              for i = 1, #permission_str do
                local char = permission_str:sub(i, i)
                table.insert(hls, { permission_hlgroups[char], i - 1, i })
              end
              return hls
            end,
          },
          { 'size', highlight = 'Special' },
          { 'mtime', highlight = 'Number' },
          {
            'icon',
            default_file = icon_file,
            directory = icon_dir,
            add_padding = false,
          },
        },
        win_options = {
          number = false,
          relativenumber = false,
          signcolumn = 'no',
          foldcolumn = '0',
          statuscolumn = '',
        },
        cleanup_delay_ms = false,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = true,
        use_default_keymaps = false,
        view_options = {
          is_always_hidden = function(name) return name == '..' end,
        },
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['K'] = preview_mapping,
          ['<C-k>'] = preview_mapping,
          ['-'] = 'actions.parent',
          ['='] = 'actions.select',
          ['+'] = 'actions.select',
          ['<CR>'] = 'actions.select',
          ['<C-h>'] = 'actions.toggle_hidden',
          ['gh'] = 'actions.toggle_hidden',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['go'] = {
            mode = 'n',
            buffer = true,
            desc = 'Choose an external program to open the entry under the cursor',
            callback = function()
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if not entry or not dir then return end
              local entry_path = vim.fs.joinpath(dir, entry.name)
              local response
              vim.ui.input({
                prompt = 'Open with: ',
                completion = 'shellcmd',
              }, function(r) response = r end)
              if not response then return end
              print('\n')
              vim.system({ response, entry_path })
            end,
          },
          ['gy'] = {
            mode = 'n',
            buffer = true,
            desc = 'Yank the filepath of the entry under the cursor to a register',
            callback = function()
              local entry = oil.get_cursor_entry()
              local dir = oil.get_current_dir()
              if not entry or not dir then return end
              local entry_path = vim.fs.joinpath(dir, entry.name)
              fn.setreg('"', entry_path)
              fn.setreg(vim.v.register, entry_path)
              vim.notify(
                string.format("[oil] yanked '%s' to register '%s'", entry_path, vim.v.register)
              )
            end,
          },
        },
        keymaps_help = {
          border = border,
        },
        float = {
          border = border,
          win_options = {
            winblend = 0,
          },
        },
        preview = {
          border = border,
          win_options = {
            winblend = 0,
          },
        },
        progress = {
          border = border,
          win_options = {
            winblend = 0,
          },
        },
      })

      local groupid = ag('OilSyncCwd', {})
      autocmd({ 'BufEnter', 'TextChanged' }, {
        desc = 'Set cwd to follow directory shown in oil buffers.',
        group = groupid,
        pattern = 'oil:///*',
        callback = function(info)
          if vim.bo[info.buf].filetype == 'oil' then
            local cwd = vim.fs.normalize(fn.getcwd(fn.winnr()))
            local oildir = vim.fs.normalize(oil.get_current_dir())
            if cwd ~= oildir and uv.fs_stat(oildir) then lcd(oildir) end
          end
        end,
      })
      autocmd('DirChanged', {
        desc = 'Let oil buffers follow cwd.',
        group = groupid,
        callback = function(info)
          if vim.bo[info.buf].filetype == 'oil' then
            vim.defer_fn(function()
              local cwd = vim.fs.normalize(fn.getcwd(fn.winnr()))
              local oildir = vim.fs.normalize(oil.get_current_dir() or '')
              if cwd ~= oildir and vim.bo.ft == 'oil' then oil.open(cwd) end
            end, 100)
          end
        end,
      })

      autocmd('BufEnter', {
        desc = 'Set last cursor position in oil buffers when editing parent dir.',
        group = ag('OilSetLastCursor', {}),
        pattern = 'oil:///*',
        callback = function()
          -- Place cursor on the alternate buffer if we are opening
          -- the parent directory of the alternate buffer
          local buf_alt = fn.bufnr('#')
          if api.nvim_buf_is_valid(buf_alt) then
            local bufname_alt = api.nvim_buf_get_name(buf_alt)
            local parent_url, basename = oil.get_buffer_parent_url(bufname_alt, true)
            if basename then require('oil.view').set_last_cursor(parent_url, basename) end
          end
        end,
      })
    end,
  },
}
