_G._fl = setmetatable({}, { __index = function(_, k) return require('fzf-lua-overlay')[k] end })
local fl = setmetatable({}, {
  __index = function(_, k) return ([[<cmd>lua _fl.%s()<cr>]]):format(k) end,
})

return {
  {
    'phanen/fzf-lua-overlay',
    cond = not vim.g.vscode,
    init = function() require('fzf-lua-overlay.providers.recentfiles').init() end,
    -- stylua: ignore
    keys = {
      { '<c-b>',         fl.buffers,               mode = { 'n', 'x' } },
      { '+<c-f>',        fl.lazy,                  mode = { 'n', 'x' } },
      { '<c-l>',         fl.files,                 mode = { 'n', 'x' } },
      { '<c-n>',         fl.live_grep_native,      mode = { 'n', 'x' } },
      { '<c-x><c-b>',    fl.complete_bline,        mode = 'i' },
      { '<c-x><c-f>',    fl.complete_file,         mode = 'i' },
      { '<c-x><c-p>',    fl.complete_path,         mode = 'i' },
      { '+e',            fl.grep_notes,            mode = { 'n' } },
      { "+fi",           fl.gitignore,             mode = { 'n', 'x' } },
      { "+fl",           fl.license,               mode = { 'n', 'x' } },
      { '+fr',           fl.rtp,                   mode = { 'n', 'x' } },
      { '+fs',           fl.scriptnames,           mode = { 'n', 'x' } },
      { 'gd',            fl.lsp_definitions,       mode = { 'n', 'x' } },
      { 'gh',            fl.lsp_code_actions,      mode = { 'n', 'x' } },
      { 'gr',            fl.lsp_references,        mode = { 'n', 'x' } },
      { '<leader><c-f>', fl.zoxide,                mode = { 'n', 'x' } },
      { '<leader><c-j>', fl.todo_comment,          mode = { 'n', 'x' } },
      { '<leader>e',     fl.find_notes,            mode = { 'n', 'x' } },
      { '<leader>fa',    fl.builtin,               mode = { 'n', 'x' } },
      { '<leader>fc',    fl.awesome_colorschemes,  mode = { 'n', 'x' } },
      { "<leader>fdb",   fl.dap_breakpoints,       mode = { 'n', 'x' } },
      { "<leader>fdc",   fl.dap_configurations,    mode = { 'n', 'x' } },
      { "<leader>fde",   fl.dap_commands,          mode = { 'n', 'x' } },
      { "<leader>fdf",   fl.dap_frames,            mode = { 'n', 'x' } },
      { "<leader>fdv",   fl.dap_variables,         mode = { 'n', 'x' } },
      { '<leader>f;',    fl.command_history,       mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags,             mode = { 'n', 'x' } },
      { '<leader>fi',    fl.git_status,            mode = { 'n', 'x' } },
      { '<leader>fk',    fl.keymaps,               mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume,                mode = 'n' },
      { '<leader>/',     fl.search_history,        mode = { 'n', 'x' } },
      { '<leader>;',     fl.spell_suggest,         mode = { 'n', 'x' } },
      { '<leader>fm',    fl.marks,                 mode = { 'n' } },
      { '<leader>fo',    fl.recentfiles,           mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols,  mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_typedefs,          mode = { 'n', 'x' } },
      { '<leader>l',     fl.find_dots,             mode = { 'n', 'x' } },
      { '<leader>t',     fl.todos,                 mode = { 'n', 'x' } },
      { '+l',            fl.grep_dots,             mode = { 'n', 'x' } },
    },
    opts = {},
    dependencies = {
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
          cwd_prompt = true,
          git_icons = false,
          winopts = { preview = { hidden = 'hidden' } },
        },
        grep = {
          file_icons = false,
          git_icons = false,
          no_header_i = true,
          -- de-dup followed?
          rg_opts = '-L --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
          actions = {
            ['ctrl-r'] = function(...) require('fzf-lua').actions.toggle_ignore(...) end,
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
              ['ctrl-s'] = { fn = function(...) require('fzf-lua').actions.git_stage_unstage(...) end, reload = true },
              ['ctrl-x'] = { fn = function(...) require('fzf-lua').actions.git_reset(...) end, reload = true },
            },
          },
        },
        actions = {
          files = {
            ['default'] = function(...) require('fzf-lua').actions.file_edit(...) end,
            ['ctrl-s'] = function(...) require('fzf-lua').actions.file_edit_or_qf(...) end,
            ['ctrl-x'] = function(...) require('fzf-lua-overlay.actions').delete_files(...) end,
            ['ctrl-y'] = function(selected, opts)
              local file = require('fzf-lua').path.entry_to_file(selected[1], opts)
              vim.fn.setreg('+', file.path)
            end,
            ['ctrl-r'] = function(...) require('fzf-lua-overlay.actions').rename_files(...) end,
            ['ctrl-o'] = function(selected, opts) -- TODO: canont reload here, should reopen buffer on window by winsize/winid
              for _, sel in ipairs(selected) do
                local file = require('fzf-lua').path.entry_to_file(sel, opts)
                vim.cmd.e(file.path)
              end
            end,
          },
        },
      },
    },
  },
}
