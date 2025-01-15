return {
  { 'phanen/fzf-lua-extra', dev = true },
  {
    'ibhagwan/fzf-lua',
    dev = true,
    cmd = 'FzfLua',
    config = function()
      local f = require('fzf-lua')
      local fa = require('fzf-lua.actions')
      local file_tabedit = function(sel, o)
        -- return fa.vimcmd_entry('tabnew +se\\ bh=wipe | <auto>', sel, o)
        return fa.vimcmd_entry('tabnew | <auto>', sel, o)
        -- return fa.vimcmd_entry('tab split | <auto>', sel, o)
      end
      local file_edit_or_tabedit = function(sel, o) -- https://github.com/ibhagwan/fzf-lua/issues/1785
        return #sel > 1 and file_tabedit(sel, o) or fa.file_edit(sel, o)
      end
      local file_rename = function(sel, o)
        local path = f.path.entry_to_file(sel[1], o).path
        local name = fs.basename(path)
        local new_name = vim.trim(fn.input { prompt = 'New name: ', default = name })
        if #new_name == 0 or new_name == name then return end
        local new_path = fs.joinpath(o.cwd or fn.getcwd(), new_name)
        vim.lsp.util.rename(path, new_path)
      end
      local file_delete = function(sel, o)
        local paths = vim.tbl_map(function(v) return f.path.entry_to_file(v, o).path end, sel)
        vim.iter(paths):filter(uv.fs_stat):each(uv.fs_unlink)
      end
      local file_create = function(_, o)
        vim.cmd.edit(fs.joinpath(o.cwd or uv.cwd(), f.get_last_query()))
      end
      g.fzf_lua_actions = {
        files = {
          ['enter'] = { fn = file_edit_or_tabedit, postfix = 'clear-selection' },
          ['ctrl-t'] = { fn = file_tabedit, postfix = 'clear-selection' },
          ['ctrl-s'] = { fn = fa.file_sel_to_qf, postfix = 'clear-selection' },
          ['alt-v'] = { fn = fa.file_vsplit, postfix = 'clear-selection' },
          ['alt-s'] = { fn = fa.file_split, postfix = 'clear-selection' },
          ['alt-q'] = { fn = fa.file_sel_to_qf, prefix = 'select-all', postfix = 'clear-selection' }, -- https://github.com/ibhagwan/fzf-lua/issues/1241
          ['alt-n'] = { fn = file_create },
          ['ctrl-x'] = { fn = file_delete, reload = true },
          ['ctrl-r'] = { fn = file_rename, reload = true },
        },
        buffers = { ['ctrl-r'] = { fn = fa.buf_del, reload = true }, ['ctrl-x'] = false },
        git_status = {
          ['ctrl-s'] = { fn = fa.git_stage_unstage, reload = true },
          ['ctrl-x'] = { fn = fa.git_reset, reload = true },
        },
        git_bcommits = { ['ctrl-o'] = function(s) vim.cmd.Gvdiffsplit(s[1]:match('[^ ]+')) end },
      }
      g.borders = {
        win = {
          down = { '┏', '━', '┓', '┃', '┫', '', '┣', '┃' },
          up = { '┣', '━', '┫', '┃', '┛', '━', '┗', '┃' },
          left = { '┳', '━', '┓', '┃', '┛', '━', '┻', '' },
          right = { '┏', '━', '┳', '', '┻', '━', '┗', '┃' },
        },
        preview = {
          down = { '┣', '━', '┫', '┃', '┛', '━', '┗', '┃' },
          up = { '┏', '━', '┓', '┃', '┫', '', '┣', '┃' },
          left = { '┏', '━', '┳', '┃', '┻', '━', '┗', '┃' },
          right = { '┳', '━', '┓', '┃', '┛', '━', '┻', '┃' },
        },
      }
      g.bottom_layout = { split = 'botright 18new +set\\ nobl', preview = { border = 'none' } }
      g.float_layout = {
        height = 0.7,
        width = 0.95,
        border = function(_, m) return m.nwin == 1 and g.border or g.borders.win[m.layout] end,
        backdrop = 100,
        title_pos = 'left',
        preview = {
          title_pos = 'left',
          scrollbar = 'border',
          delay = 50,
          border = function(_, m)
            return m.type == 'fzf' and 'border-left' or g.borders.preview[m.layout]
          end,
        },
      }
      g.cur_layout = false and g.bottom_layout or g.float_layout
      f.setup {
        'hide',
        defaults = { git_icons = false, file_icons = false, prompt = '❯ ' },
        silent = true, -- don't warn resume->reload
        previewers = {
          builtin = {
            treesitter = { sync_parsing = false },
            extensions = {
              ['png'] = { 'ueberzug' },
              ['jpeg'] = { 'ueberzug' },
              ['gif'] = { 'ueberzug' },
            },
          },
        },
        winopts = function() return g.cur_layout end,
        fzf_opts = {
          ['--info'] = 'inline:❮ ',
          ['--history'] = fs.joinpath(env.XDG_DATA_HOME, 'fzfhistory'),
          -- ['--listen'] = true,
        },
        keymap = {
          builtin = {
            ['<a-;>'] = 'toggle-preview',
            ['<c-d>'] = 'preview-page-down',
            ['<c-u>'] = 'preview-page-up',
            ['<a-l>'] = 'toggle-fullscreen',
          },
          fzf = { -- required here again, anyway
            ['ctrl-q'] = 'toggle-all',
            ['alt-;'] = 'toggle-preview',
          },
        },
        lsp = {
          async_or_timeout = 5000,
          jump_to_single_result = true,
          includeDeclaration = false,
          ignore_current_line = true,
          unique_line_items = true,
          code_actions = { previewer = 'codeaction_native' },
        },
        git = {
          status = { actions = g.fzf_lua_actions.git_status },
          bcommits = { actions = g.fzf_lua_actions.git_bcommits },
        },
        marks = {
          fzf_opts = { ['--no-multi'] = false },
          actions = { ['ctrl-r'] = { fn = fa.mark_del, reload = true } },
        },
        buffers = { actions = g.fzf_lua_actions.buffers },
        helptags = { winopts = { preview = { hidden = true } } },
        manpages = {
          cmd = 'man -kl .',
          winopts = { preview = { hidden = true } },
          actions = { ['ctrl-g'] = { fn = function() end, reload = true } },
        },
        diagnostics = {},
        commands = { actions = { enter = fa.ex_run_cr, ['ctrl-e'] = fa.ex_run } },
        spell_suggest = { winopts = { height = 0.2, width = 0.2, border = 'none' } },
        actions = { files = g.fzf_lua_actions.files },
      }
    end,
  },
}
