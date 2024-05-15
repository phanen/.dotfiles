local fl = setmetatable({}, {
  __index = function(_, k) return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k) end,
})

-- local fl = 'fzf-lua-overlay'
return {
  {
    'phanen/fzf-lua-overlay',
    cond = not vim.g.vscode,
    init = function() require('fzf-lua-overlay').init() end,
    -- stylua: ignore
    keys = {
      { '<c-b>',      fl.buffers,               mode = { 'n', 'x' } },
      { '+<c-f>',     fl.lazy,                  mode = { 'n', 'x' } },
      { ' <c-f>',     fl.zoxide,                mode = { 'n', 'x' } },
      { ' <c-j>',     fl.todo_comment,          mode = { 'n', 'x' } },
      { '<c-l>',      fl.files,                 mode = { 'n', 'x' } },
      { '<c-n>',      fl.live_grep_native,      mode = { 'n', 'x' } },
      { '<c-x><c-l>', fl.complete_line,        mode = 'i' },
      { '<c-x><c-b>', fl.complete_bline,        mode = 'i' },
      { '<c-x><c-f>', fl.complete_file,         mode = 'i' },
      { '<c-x><c-p>', fl.complete_path,         mode = 'i' },
      { ' e',         fl.find_notes,            mode = { 'n', 'x' } },
      { '+e',         fl.grep_notes,            mode = { 'n' } },
      { ' fa',        fl.builtin,               mode = { 'n', 'x' } },
      { ' fc',        fl.awesome_colorschemes,  mode = { 'n', 'x' } },
      { ' fdb',       fl.dap_breakpoints,       mode = { 'n', 'x' } },
      { ' fdc',       fl.dap_configurations,    mode = { 'n', 'x' } },
      { ' fde',       fl.dap_commands,          mode = { 'n', 'x' } },
      { ' fdf',       fl.dap_frames,            mode = { 'n', 'x' } },
      { ' fdv',       fl.dap_variables,         mode = { 'n', 'x' } },
      { ' f;',        fl.command_history,       mode = { 'n', 'x' } },
      { ' fh',        fl.help_tags,             mode = { 'n', 'x' } },
      { '+fi',        fl.gitignore,             mode = { 'n', 'x' } },
      { ' fi',        fl.git_status,            mode = { 'n', 'x' } },
      { ' fj',        fl.tagstack,              mode = { 'n', 'x' } },
      { ' fk',        fl.keymaps,               mode = { 'n', 'x' } },
      { '+fl',        fl.license,               mode = { 'n', 'x' } },
      { '  ',         fl.resume,                mode = 'n' },
      { ' /',         fl.search_history,        mode = { 'n', 'x' } },
      { ' ;',         fl.spell_suggest,         mode = { 'n', 'x' } },
      { ' fm',        fl.marks,                 mode = { 'n' } },
      { ' fo',        fl.recentfiles,           mode = { 'n', 'x' } },
      { '+fr',        fl.rtp,                   mode = { 'n', 'x' } },
      { ' fs',        fl.lsp_document_symbols,  mode = { 'n', 'x' } },
      { '+fs',        fl.scriptnames,           mode = { 'n', 'x' } },
      { ' fw',        fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { 'gd',         fl.lsp_definitions,       mode = { 'n', 'x' } },
      { ' gd',        fl.lsp_typedefs,          mode = { 'n', 'x' } },
      { 'gh',         fl.lsp_code_actions,      mode = { 'n', 'x' } },
      { 'gr',         fl.lsp_references,        mode = { 'n', 'x' } },
      { ' l',         fl.find_dots,             mode = { 'n', 'x' } },
      { '+l',         fl.grep_dots,             mode = { 'n', 'x' } },
    },
    opts = {},
  },
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    opts = {
      'default-title',
      previewers = {
        builtin = {
          extensions = {
            ['png'] = { 'viu', '-b' },
            ['jpg'] = { 'ueberzug' },
            ['jpeg'] = { 'ueberzug' },
            ['gif'] = { 'ueberzug' },
            ['svg'] = { 'ueberzug' },
          },
          ueberzug_scaler = 'cover',
        },
      },
      winopts = { preview = { delay = 30 }, height = 0.6 },
      fzf_opts = {
        ['--history'] = vim.g.state_path .. '/telescope_history',
        ['--info'] = 'inline',
      },
      keymap = {
        builtin = {
          ['<c-\\>'] = 'toggle-preview',
          ['<c-d>'] = 'preview-page-down',
          ['<c-u>'] = 'preview-page-up',
        },
        fzf = {},
      },
      files = {
        -- formatter = 'path.filename_first',
        cwd_prompt = true,
        git_icons = false,
        winopts = { preview = { hidden = 'hidden' } },
      },
      grep = {
        file_icons = false,
        git_icons = false,
        no_header_i = true,
        -- de-dup followed?
        rg_opts = '-L --no-messages --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        actions = {
          ['ctrl-r'] = function(...) require('fzf-lua').actions.toggle_ignore(...) end,
        },
      },
      buffers = { formatter = 'path.filename_first' },
      lsp = {
        jump_to_single_result = true,
        includeDeclaration = false,
        ignore_current_line = true,
      },
      git = {
        status = {
          previewer = 'git_diff',
          -- preview_pager = false,
          -- stylua: ignore
          actions = {
            ["right"]  = false,
            ["left"]   = false,
            ['ctrl-s'] = { fn = function(...) require('fzf-lua').actions.git_stage_unstage(...) end, reload = true },
            ['ctrl-x'] = { fn = function(...) require('fzf-lua').actions.git_reset(...) end, reload = true },
          },
        },
      },
      actions = {
        files = {
          ['default'] = function(...) require('fzf-lua').actions.file_edit(...) end,
          ['ctrl-n'] = function(...) require('fzf-lua-overlay.actions').file_create_open(...) end,
          ['ctrl-s'] = function(...) require('fzf-lua').actions.file_edit_or_qf(...) end,
          ['ctrl-x'] = {
            fn = function(...) require('fzf-lua-overlay.actions').file_delete(...) end,
            reload = true,
          },
          ['ctrl-y'] = {
            fn = function(selected, opts)
              local paths = vim.tbl_map(
                function(v) return require('fzf-lua').path.entry_to_file(v, opts).path end,
                selected
              )
              vim.fn.setreg('+', table.concat(paths, ' '))
            end,
            exec_silent = true,
          },
          ['ctrl-r'] = {
            -- TODO: cursor missed
            fn = function(...) require('fzf-lua-overlay.actions').file_rename(...) end,
            reload = true,
          },
          ['ctrl-o'] = {
            -- TODO: canont reload here, should reopen buffer on window by winsize/winid
            fn = function(selected, opts)
              for _, sel in ipairs(selected) do
                local file = require('fzf-lua').path.entry_to_file(sel, opts)
                vim.cmd.e(file.path)
              end
            end,
            -- exec_silent = true,
            -- reload = true,
          },
          ['ctrl-l'] = {
            fn = function()
              local fzf = require('fzf-lua')
              fzf.builtin({
                actions = {
                  ['default'] = function(selected)
                    fzf[selected[1]]({
                      query = fzf.config.__resume_data.last_query,
                      cwd = fzf.config.__resume_data.opts.cwd,
                    })
                  end,
                },
              })
            end,
          },
        },
      },
    },
  },
}
