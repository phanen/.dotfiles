return {
  -- FIXME: fzf-lua fzf window colide with toggleterm <c-;>
  {
    'phanen/fzf-lua-overlay',
    main = 'flo',
    cond = not vim.g.vscode,
    init = function() require('flo').init() end,
    -- stylua: ignore
    keys = function()
      local f = require('flo')
      return {
        { '<c-b>',      f.buffers,               mode = { 'n', 'x' } },
        { '+<c-f>',     f.lazy,                  mode = { 'n', 'x' } },
        { ' <c-f>',     f.zoxide,                mode = { 'n', 'x' } },
        { ' <c-j>',     f.todo_comment,          mode = { 'n', 'x' } },
        { '<c-l>',      f.files,                 mode = { 'n', 'x' } },
        { '<c-n>',      f.live_grep_native,      mode = { 'n', 'x' } },
        { '<c-x><c-b>', f.complete_bline,        mode = 'i' },
        { '<c-x><c-f>', f.complete_file,         mode = 'i' },
        { '<c-x><c-l>', f.complete_line,         mode = 'i' },
        { '<c-x><c-p>', f.complete_path,         mode = 'i' },
        { ' e',         f.find_notes,            mode = { 'n', 'x' } },
        { '+e',         f.grep_notes,            mode = { 'n', 'x' } },
        { ' fa',        f.builtin,               mode = { 'n', 'x' } },
        { 'f<c-e>',     f.grep_notes,            mode = { 'n', 'x' } },
        { ' fc',        f.awesome_colorschemes,  mode = { 'n', 'x' } },
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
        { ' fo',        f.recentfiles,           mode = { 'n', 'x' } },
        { 'fp',         f.loclist,               mode = { 'n', 'x' } },
        { 'fq',         f.quickfix,              mode = { 'n', 'x' } },
        { '  ',         f.resume,                mode = { 'n', 'x' } },
        { '+fr',        f.rtp,                   mode = { 'n', 'x' } },
        { ' /',         f.search_history,        mode = { 'n', 'x' } },
        { ' fs',        f.lsp_document_symbols,  mode = { 'n', 'x' } },
        { '+fs',        f.scriptnames,           mode = { 'n', 'x' } },
        { ' ;',         f.spell_suggest,         mode = { 'n', 'x' } },
        { ' fw',        f.lsp_workspace_symbols, mode = { 'n', 'x' } },
        { 'g<c-d>',     f.lsp_declarations,      mode = { 'n', 'x' } },
        { 'g<c-i>',     f.lsp_implementations,   mode = { 'n', 'x' } },
        { 'gd',         f.lsp_definitions,       mode = { 'n', 'x' } },
        { 'gh',         f.lsp_code_actions,      mode = { 'n', 'x' } },
        { 'gm',         f.lsp_typedefs,          mode = { 'n', 'x' } },
        { 'gr',         f.lsp_references,        mode = { 'n', 'x' } },
        { ' l',         f.find_dots,             mode = { 'n', 'x' } },
        { '+l',         f.grep_dots,             mode = { 'n', 'x' } },
        { 'z=',         f.spell_suggest,         mode = { 'n', 'x' } },
      }
    end,
    opts = {},
    -- dependencies = 'ibhagwan/fzf-lua',
  },
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua *',
    config = function()
      local f = require('fzf-lua')
      local a = require('flo.actions')
      f.setup {
        'default-title',
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'viu', '-b' },
              ['jpg'] = { 'ueberzug' },
              ['jpeg'] = { 'ueberzug' },
              ['gif'] = { 'ueberzug' },
              ['svg'] = { 'chafa', '{file}' },
            },
            ueberzug_scaler = 'cover',
          },
          man = { -- use man-db
            cmd = 'man %s | col -bx',
          },
        },
        winopts = {
          height = 0.6,
          border = g.border,
          backdrop = 90,
          preview = { delay = 40 },
        },
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
          -- FIXME(libvterm): not work well with c-\\ in terminal
          fzf = {},
        },
        awesome_colorschemes = {
          prompt = 'LiveColors> ',
          winopts = { row = 0.3, col = 0.5, width = 0.3, backdrop = false },
          max_threads = 5,
          dbfile = 'data/colorschemes.json',
        },
        -- TODO: exclude current buffer
        files = {
          -- this work as require path: `_fmt = M.globals["formatters." .. opts.formatter]`
          -- formatter = 'path.filename_first',
          -- formatter = 'path.dirname_first',
          cwd_prompt = true,
          git_icons = false,
          winopts = { preview = { hidden = 'hidden' } },
          actions = {
            ['alt-n'] = a.file_create_open,
          },
          -- no_header = true,
          no_header_i = true,
        },
        oldfiles = { -- also use this config for recentfiles
          path_shorten = 4,
          previewer = 'builtin', -- need it to make recentfiles previewable
          actions = {
            ['default'] = f.actions.file_edit,
            ['ctrl-o'] = { fn = a.file_edit_bg, resume = true },
          },
        },
        grep = {
          debug = false,
          file_icons = false,
          git_icons = false,
          -- no_header = true,
          no_header_i = true,
          -- de-dup followed?
          rg_opts = '-L --no-messages --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
          -- multiline = 0, -- fzf 0.53+
          actions = {
            ['ctrl-r'] = f.actions.toggle_ignore,
            ['alt-n'] = function() end,
          },
        },
        buffers = { formatter = 'path.filename_first' },
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
            -- previewer = fn.executable('delta') == 1 and 'codeaction_native' or 'codeaction',
            previewer = 'codeaction', -- no highlgiht?
          },
        },
        git = {
          status = {
            previewer = 'git_diff',
          -- preview_pager = false,
          -- stylua: ignore
          actions = {
            ["right"]  = false,
            ["left"]   = false,
            ['ctrl-s'] = { fn = f.actions.git_stage_unstage, reload = true },
            ['ctrl-x'] = { fn = f.actions.git_reset, reload = true },
          },
          },
        },
        helptags = {
          winopts = { preview = { hidden = 'hidden' } },

          actions = {
            ['ctrl-o'] = {
              fn = a.file_edit_bg,
              -- using `reload = true` will fallback to `resume`
              resume = true,
            },
          },
        },
        actions = {
          files = {
            ['default'] = f.actions.file_edit,
            -- ['ctrl-s'] = f.actions.file_edit_or_qf,
            ['ctrl-s'] = f.actions.file_sel_to_qf,
            -- ['ctrl-s'] = fzf.actions.file_sel_to_ll,
            ['alt-q'] = { fn = f.actions.file_sel_to_qf, prefix = 'select-all' },
            -- ['alt-s'] = {
            --   fn = function(sel) print('no items:', #sel) end,
            --   prefix = 'transform([ $FZF_SELECT_COUNT -eq 0 ] && echo select-all)',
            -- },
            ['ctrl-x'] = { fn = a.file_delete, reload = true },
            ['ctrl-r'] = { fn = a.file_rename, reload = true }, -- TODO: cursor missed
            ['ctrl-o'] = { fn = a.file_edit_bg, reload = true }, -- TODO: not work well in rg
            ['ctrl-y'] = {
              fn = function(selected, opts)
                local paths = vim
                  .iter(selected)
                  :map(function(v) return f.path.entry_to_file(v, opts).path end)
                  :totable()
                fn.setreg('+', table.concat(paths, ' '))
              end,
              -- exec_silent = true,
            },
            ['ctrl-l'] = {
              fn = function()
                f.builtin {
                  actions = {
                    ['default'] = function(selected)
                      f[selected[1]] {
                        query = f.config.__resume_data.last_query,
                        cwd = f.config.__resume_data.opts.cwd,
                      }
                    end,
                  },
                }
              end,
            },
          },
        },
        fzf_colors = {
          -- ['fg'] = { 'fg', 'NormalFloat' },
          -- ['bg'] = { 'bg', 'NormalFloat' },
          ['hl'] = { 'fg', 'Statement' },
          ['fg+'] = { 'fg', 'NormalFloat' },
          ['bg+'] = { 'bg', 'CursorLine' },
          ['hl+'] = { 'fg', 'Statement' },
          ['info'] = { 'fg', 'PreProc' },
          -- ['prompt'] = { 'fg', 'Conditional' },
          -- ['pointer'] = { 'fg', 'Exception' },
          -- ['marker'] = { 'fg', 'Keyword' },
          -- ['spinner'] = { 'fg', 'Label' },
          -- ['header'] = { 'fg', 'Comment' },
          -- ['gutter'] = { 'bg', 'NormalFloat' },
        },
      }
    end,
  },
  { 'vijaymarupudi/nvim-fzf-commands' },
  { 'vijaymarupudi/nvim-fzf', main = 'fzf' },
  {
    'tani/pickup.nvim',
    cond = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  { -- https://github.com/junegunn/fzf.vim/issues/837
    'junegunn/fzf.vim',
    -- cond = not vim.g.vscode,
    cond = true,
    cmd = {
      'Files',
      'RG',
      'Rg',
      'Commands',
    },
    keys = {
      -- { ' <c-l>', '<cmd>Files<cr>', mode = { 'n', 'x' } },
      { ' <c-k>', '<cmd>Rg<cr>', mode = { 'n', 'x' } },
      -- { '<leader><c-j>', '<cmd>RgD -path=~/notes -pattern=<cr>', mode = { 'n', 'x' } },
    },
    config = function()
      vim.cmd [[
    function! RgDir(isFullScreen, args)
    let l:restArgs = [a:args]

    let l:restArgs = split(l:restArgs[0], '-pattern=', 1)
    let l:pattern = join(l:restArgs[1:], '')

    let l:restArgs = split(l:restArgs[0], '-path=', 1)
    " Since 8.0.1630 vim has a built-in trim() function
    let l:path = trim(l:restArgs[1])

    call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case " .. shellescape(l:pattern), 1, {'dir': l:path}, a:isFullScreen)
    endfunction

    " the path param should not have `-pattern=`
    command! -bang -nargs=+ -complete=dir RgD call RgDir(<bang>0, <q-args>)
    ]]
    end,
    dependencies = { 'junegunn/fzf' },
  },
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
