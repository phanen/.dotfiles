return {
  { 'phanen/fzf-lua-overlay', main = 'flo', opts = {} },
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    config = function()
      local a = require('flo.actions')
      local f = require('fzf-lua')
      local fa = require('fzf-lua.actions')
      local file_edit_or_tabedit = function(sel, o)
        return #sel > 1 and fa.file_tabedit(sel, o) or fa.file_edit(sel, o)
      end
      local file_edit_or_tabedit_hide = function(sel, o)
        f.hide()
        file_edit_or_tabedit(sel, o)
      end
      g.fzf_lua_file_actions = {
        ['enter'] = file_edit_or_tabedit, -- 'default' cannot be overrided by `complete_path`
        ['ctrl-t'] = fa.file_tabedit,
        ['ctrl-s'] = fa.file_sel_to_qf,
        ['alt-v'] = { fn = fa.file_vsplit },
        ['alt-s'] = { fn = fa.file_split },
        -- https://github.com/ibhagwan/fzf-lua/issues/1241
        ['alt-q'] = { fn = fa.file_sel_to_qf, prefix = 'select-all' },
        ['alt-n'] = a.file_create_open,
        ['ctrl-x'] = { fn = a.file_delete, reload = true },
        ['ctrl-r'] = { fn = a.file_rename, reload = true },
        ['ctrl-y'] = a.yank,
        ['ctrl-o'] = { fn = file_edit_or_tabedit_hide, exec_silent = true },
      }
      f.setup {
        'default-title',
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'ueberzug' },
              ['jpeg'] = { 'ueberzug' },
              ['gif'] = { 'ueberzug' },
            },
            ueberzug_scaler = 'cover',
            treesitter = { context = true },
          },
          man = { -- use man-db
            cmd = 'man %s | col -bx',
          },
        },
        winopts = { -- 'keep'
          height = 0.7,
          width = 0.9,
          border = g.border,
          backdrop = 100,
          -- treesitter = true,
          preview = { delay = 50, border = g.border },
        },
        -- easy to see count (but not spinner)
        fzf_opts = {
          ['--info'] = 'inline',
          ['--preview-window'] = 'border-none',
        },
        keymap = {
          builtin = {
            ['<a-esc>'] = 'abort',
            ['<esc>'] = 'hide',
            ['<a-;>'] = 'toggle-preview',
            ['<c-d>'] = 'preview-page-down',
            ['<c-u>'] = 'preview-page-up',
            ['<c-l>'] = 'toggle-fullscreen',
          },
          fzf = { -- don't override it anyway
            ['ctrl-q'] = 'toggle-all',
          },
        },
        files = { git_icons = false, no_header_i = true },
        oldfiles = { include_current_session = true },
        grep = { multiprocess = false, file_icons = false, git_icons = false, no_header_i = true }, -- live_grep_glob_st
        lsp = {
          async_or_timeout = 5000,
          jump_to_single_result = true,
          includeDeclaration = false,
          ignore_current_line = true,
          unique_line_items = true,
          code_actions = {
            previewer = fn.executable('delta') == 1 and 'codeaction_native' or 'codeaction',
          },
        },
        git = {
          status = {
            actions = {
              ['ctrl-s'] = { fn = fa.git_stage_unstage, reload = true },
              ['ctrl-x'] = { fn = fa.git_reset, reload = true },
            },
          },
          bcommits = {
            actions = { ['ctrl-o'] = function(s) vim.cmd.DiffviewOpen(s[1]:match('[^ ]+')) end },
          },
        },
        buffers = {
          actions = {
            ['ctrl-r'] = { fn = function() u.bufop.delete_irrelavant() end, reload = true },
          },
        },
        lines = { winopts = { preview = { hidden = 'hidden' } } },
        blines = { winopts = { preview = { hidden = 'hidden' } } },
        helptags = { winopts = { preview = { hidden = 'hidden' } } },
        manpages = { winopts = { preview = { hidden = 'hidden' } } },
        commands = {
          winopts = { preview = { hidden = 'hidden' } },
          actions = { enter = fa.ex_run_cr, ['ctrl-e'] = fa.ex_run },
        },
        spell_suggest = { winopts = { border = 'none', backdrop = false } },
        complete_path = { file_icons = true, previewer = 'builtin' },
        actions = { files = g.fzf_lua_file_actions },
        filetypes = { file_icons = 'mini', color_icons = true },
      }
    end,
  },
}
