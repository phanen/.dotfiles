return {
  {
    'phanen/fzf-lua-overlay',
    main = 'flo',
    cond = not vim.g.vscode,
    init = u.lazy_req('flo').init, -- TODO: remove this
    keys = function()
      local f = u.lazy_req('flo')
      -- stylua: ignore
      return {
        { '<c-b>',      f.recentfiles,           mode = { 'n', 'x' } },
        { ' <c-f>',     f.zoxide,                mode = { 'n', 'x' } },
        { ' <c-j>',     f.todo_comment,          mode = { 'n', 'x' } },
        { '<c-l>',      f.files,                 mode = { 'n', 'x' } },
        { '<c-n>',      f.live_grep_native,      mode = { 'n', 'x' } },
        { '<c-x><c-b>', f.complete_bline,        mode = 'i' },
        { '<c-x><c-f>', f.complete_file,         mode = 'i' },
        { '<c-x><c-l>', f.complete_line,         mode = 'i' },
        { '<c-x><c-p>', f.complete_path,         mode = 'i' },
        { ' e',         f.find_notes,            mode = { 'n', 'x' } },
        { ' fa',        f.builtin,               mode = { 'n', 'x' } },
        { 'f<c-e>',     f.grep_notes,            mode = { 'n', 'x' } },
        { ' fc',        f.awesome_colorschemes,  mode = { 'n', 'x' } },
        { 'f<c-f>',     f.lazy,                  mode = { 'n', 'x' } },
        { 'f<c-l>',     f.grep_dots,             mode = { 'n', 'x' } },
        { 'f<c-o>',     f.recentfiles,           mode = { 'n', 'x' } },
        { 'f<c-s>',     f.commands,              mode = { 'n', 'x' } },
        { ' fdb',       f.dap_breakpoints,       mode = { 'n', 'x' } },
        { ' fdc',       f.dap_configurations,    mode = { 'n', 'x' } },
        { ' fde',       f.dap_commands,          mode = { 'n', 'x' } },
        { ' fdf',       f.dap_frames,            mode = { 'n', 'x' } },
        { ' fdv',       f.dap_variables,         mode = { 'n', 'x' } },
        { ' f;',        f.command_history,       mode = { 'n', 'x' } },
        { ' fh',        f.help_tags,             mode = { 'n', 'x' } },
        { '+fi',        f.gitignore,             mode = { 'n', 'x' } },
        { ' fi',        f.git_status,            mode = { 'n', 'x' } },
        { ' fj',        f.tagstack,              mode = { 'n', 'x' } },
        { ' fk',        f.keymaps,               mode = { 'n', 'x' } },
        { '+fl',        f.license,               mode = { 'n', 'x' } },
        { ' fm',        f.marks,                 mode = { 'n', 'x' } },
        { ' fo',        f.oldfiles,              mode = { 'n', 'x' } },
        { ' fp',        f.loclist,               mode = { 'n', 'x' } },
        { ' fq',        f.quickfix,              mode = { 'n', 'x' } },
        { '  ',         f.resume,                mode = { 'n', 'x' } },
        { '+fr',        f.rtp,                   mode = { 'n', 'x' } },
        { ' /',         f.search_history,        mode = { 'n', 'x' } },
        { ' fs',        f.lsp_document_symbols,  mode = { 'n', 'x' } },
        { '+fs',        f.scriptnames,           mode = { 'n', 'x' } },
        { ' fw',        f.lsp_workspace_symbols, mode = { 'n', 'x' } },
        { 'g<c-d>',     f.lsp_declarations,      mode = { 'n', 'x' } },
        { 'g<c-i>',     f.lsp_implementations,   mode = { 'n', 'x' } },
        { 'gd',         f.lsp_definitions,       mode = { 'n', 'x' } },
        { 'gh',         f.lsp_code_actions,      mode = { 'n', 'x' } },
        { 'gm',         f.lsp_typedefs,          mode = { 'n', 'x' } },
        { 'gr',         f.lsp_references,        mode = { 'n', 'x' }, nowait = true },
        { ' l',         f.find_dots,             mode = { 'n', 'x' } },
        { '+l',         f.grep_dots,             mode = { 'n', 'x' } },
        { 'U',          f.undo,                  mode = { 'n', 'x' } },
        { 'z=',         f.spell_suggest,         mode = { 'n', 'x' } },
      }
    end,
  },
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua *',
    keys = ' <c-e>',
    dependencies = 'nvim-treesitter', -- must be setup for preview
    config = function()
      local f = require('fzf-lua')
      local a = require('flo.actions')
      local path = g.state_path .. '/file_ignore_patterns.conf'
      map.n(' <c-e>', function() vim.cmd.edit(path) end)
      f.setup {
        'default-title',
        -- TODO(upstream): dynamic filter, popup a rule windows
        file_ignore_patterns = function()
          local content = u.fs.read_file(path)
          local patterns = content and vim.split(content, '\n', { trimempty = true }) or {}
          patterns = vim.tbl_filter(
            function(line) return line ~= '' and not vim.startswith(line, '#') end,
            patterns
          )
          return patterns
        end,
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'ueberzug' },
              ['jpeg'] = { 'ueberzug' },
              ['gif'] = { 'ueberzug' },
            },
            ueberzug_scaler = 'cover',
          },
          man = { -- use man-db
            cmd = 'man %s | col -bx',
          },
        },
        winopts_fn = function()
          -- vim.o.columns / max_columns
          -- vim.o.lines / min_columns
          return {
            height = 0.6,
            width = 0.85,
            border = g.border,
            backdrop = 90,
            preview = { delay = 40 },
          }
        end,
        fzf_opts = {
          ['--history'] = vim.g.state_path .. '/telescope_history',
          ['--info'] = 'inline', -- easy to see count
          ['--border'] = 'none',
        },
        keymap = {
          builtin = {
            -- FIXME(upstream): twice, v:null
            -- vim.keymap.set("t", "<esc>", [[<cmd>lua require('fzf-lua.win').hide()<cr>)]], { nowait = true, buffer = self.fzf_bufnr })
            ['<esc>'] = 'hide',
            -- TODO: bind origin esc to another key e.g. <a-esc>
            ['<c-\\>'] = 'toggle-preview',
            ['<c-d>'] = 'preview-page-down',
            ['<c-u>'] = 'preview-page-up',
          },
          fzf = {}, -- FIXME(libvterm): c-\\ work int fzf, but not in nvim's term
        },
        files = {
          cwd_prompt = true,
          git_icons = false,
          winopts = { preview = { hidden = 'hidden' } },
          no_header_i = true,
        },
        oldfiles = {
          -- path_shorten = 4,
          include_current_session = true, -- TODO: buffer! t is defered (unknown)
          previewer = 'builtin', -- need it to make recentfiles previewable
          winopts = { preview = { hidden = 'hidden' } },
        },
        grep = {
          file_icons = false,
          git_icons = false,
          no_header_i = true,
          -- rg_opts = '-L --no-messages --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
          -- multiline = 1, -- fzf 0.53+
          actions = { ['ctrl-r'] = f.actions.toggle_ignore },
        },
        commands = {
          sort_lastused = true,
          include_builtin = true,
        },
        lsp = {
          -- async = true,
          async_or_timeout = 5000,
          jump_to_single_result = true,
          includeDeclaration = false,
          ignore_current_line = true,
          unique_line_items = true,
          code_actions = {
            previewer = fn.executable('delta') == 1 and 'codeaction_native' or 'codeaction',
            -- previewer = 'codeaction', -- TODO: no highlgiht?
          },
        },
        git = {
          status = {
            previewer = 'git_diff',
            -- preview_pager = false,
            actions = {
              ['ctrl-s'] = { fn = f.actions.git_stage_unstage, reload = true },
              ['ctrl-x'] = { fn = f.actions.git_reset, reload = true },
            },
          },
        },
        helptags = {
          winopts = { preview = { hidden = 'hidden' } },
          actions = { ['ctrl-o'] = { fn = a.file_edit_bg, exec_silent = true } },
        },
        spell_suggest = {
          winopts = { border = 'none', backdrop = false },
        },
        complete_path = { -- TODO: `:setf dir`
          file_icons = true,
          color_icons = true,
          previewer = 'builtin',
          winopts = { preview = { hidden = 'hidden' } },
        },
        actions = {
          files = {
            ['enter'] = f.actions.file_edit, -- 'default' cannot be overrided by `complete_path`
            ['ctrl-s'] = f.actions.file_sel_to_qf,
            -- https://github.com/ibhagwan/fzf-lua/issues/1241
            ['alt-q'] = { fn = f.actions.file_sel_to_qf, prefix = 'select-all' },
            ['alt-n'] = a.file_create_open,
            ['ctrl-x'] = { fn = a.file_delete, reload = true },
            ['ctrl-r'] = { fn = a.file_rename, reload = true },
            ['ctrl-o'] = { fn = a.file_edit_bg, exec_silent = true },
            ['ctrl-y'] = function(selected, opts)
              local paths = vim
                .iter(selected)
                :map(function(v) return f.path.entry_to_file(v, opts).path end)
                :join(' ')
              fn.setreg('+', paths)
            end,
          },
        },
      }
    end,
  },
  { 'vijaymarupudi/nvim-fzf-commands' },
  { 'vijaymarupudi/nvim-fzf', main = 'fzf' },
  { -- https://github.com/junegunn/fzf.vim/issues/837
    'junegunn/fzf.vim',
    cond = not vim.g.vscode,
    cmd = { 'Files', 'RG', 'Rg', 'Commands' },
    dependencies = { 'junegunn/fzf' },
  },
  { 'Yggdroot/LeaderF', build = ':LeaderfInstallCExtension', lazy = false },
  {
    'leisiji/fzf_utils',
    cond = false,
    cmd = 'FzfCommand',
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    cond = true,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function() require('telescope').load_extension 'fzf' end,
      },
    },
    cmd = 'Telescope',
    keys = { { '<leader>fb', '<cmd>Telescope builtin<cr>' } },
    config = function()
      local ta = require 'telescope.actions'
      local tas = require 'telescope.actions.state'
      local tal = require 'telescope.actions.layout'
      require('telescope').setup {
        defaults = {
          sorting_strategy = 'ascending',
          preview = { hide_on_startup = true },
          layout_config = {
            horizontal = { height = 0.65, preview_width = 0.55 },
            prompt_position = 'top',
          },
          file_ignore_patterns = { 'LICENSE', '*-lock.json' },
          mappings = {
            i = {
              ['<c-n>'] = ta.cycle_history_next,
              ['<c-p>'] = ta.cycle_history_prev,
              ['<c-u>'] = false,
              ['<c-d>'] = ta.preview_scrolling_down,
              ['<c-v>'] = false,
              ['<c-\\>'] = tal.toggle_preview,
              ['<esc>'] = ta.close,
              ['<c-j>'] = ta.move_selection_next,
              ['<c-k>'] = ta.move_selection_previous,
              ['<a-m>'] = tal.toggle_mirror,
              ['<a-p>'] = tal.cycle_layout_prev,
              ['<a-n>'] = tal.cycle_layout_next,
              ['<c-l>'] = function(_)
                local entry = tas.get_selected_entry()
                if entry == nil then return true end
                local prompt_text = entry.text or entry[1]
                fn.setreg('+', prompt_text)
                api.nvim_paste(prompt_text, true, 1)
                return true
              end,
              ['<c-o>'] = function(bufnr)
                ta.select_default(bufnr)
                require('telescope.builtin').resume()
              end,
              ['<c-s>'] = ta.add_selected_to_qflist,
              ['<cr>'] = function(bufnr)
                local picker = tas.get_current_picker(bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                  ta.close(bufnr)
                  vim.iter(multi):each(function(v) vim.cmd.e(v.path) end)
                else
                  ta.select_default(bufnr)
                end
              end,
            },
          },
        },
      }
    end,
  },
}
