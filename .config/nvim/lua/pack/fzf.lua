local fl = setmetatable({}, {
  __index = function(_, k) return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k) end,
})

return {
  {
    'junegunn/fzf.vim',
    cmd = { 'Files', 'RG', 'Rg' },
    dependencies = { 'junegunn/fzf' },
  },
  {
    'phanen/fzf-lua-overlay',
    init = function() require('fzf-lua-overlay.providers.recentfiles').init() end,
    -- stylua: ignore
    keys = {
      { '<c-b>',         fl.buffers,               mode = { 'n', 'x' } },
      { '+<c-f>',        fl.plugins,               mode = { 'n', 'x' } },
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
      { '<c-h>',         fl.help_tags,             mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags,             mode = { 'n', 'x' } },
      { '<leader>fi',    fl.git_status,            mode = { 'n', 'x' } },
      { '<leader>fj',    fl.grep_dots,             mode = { 'n', 'x' } },
      { '<leader>fk',    fl.keymaps,               mode = { 'n', 'x' } },
      { '<leader>/',     fl.blines,                mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume,                mode = 'n' },
      { '<leader>;',     fl.spell_suggest,         mode = { 'n', 'x' } },
      { '<leader>fo',    fl.recentfiles,           mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols,  mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_typedefs,          mode = { 'n', 'x' } },
      { '<leader>l',     fl.find_dots,             mode = { 'n', 'x' } },
      { '+l',            fl.grep_dots,             mode = { 'n', 'x' } },
    },
    opts = {},
    dependencies = {
      'ibhagwan/fzf-lua',
      cmd = { 'FzfLua' },
      opts = {
        previewers = {
          builtin = {
            extensions = {
              ['png'] = { 'viu', '-b' },
              ['jpg'] = { 'ueberzug' },
            },
            ueberzug_scaler = 'cover',
          },
        },
        winopts = { preview = { delay = 30 }, height = 0.6 },
        fzf_opts = {
          ['--history'] = vim.fn.stdpath 'state' .. '/telescope_history',
          ['--info'] = 'inline',
        },
        keymap = {
          builtin = {
            ['<c-\\>'] = 'toggle-preview',
            ['<c-d>'] = 'preview-page-down',
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
          actions = {
            ['ctrl-r'] = function(...) require('fzf-lua').actions.toggle_ignore(...) end,
          },
        },
        actions = {
          files = {
            ['default'] = function(...) require('fzf-lua').actions.file_edit(...) end,
            ['ctrl-s'] = function(...) require('fzf-lua').actions.file_edit_or_qf(...) end,
            ['ctrl-x'] = function(...) require('fzf-lua-overlay').actions.delete_files(...) end,
            ['ctrl-y'] = {
              fn = function(selected, opts)
                local file = require('fzf-lua').path.entry_to_file(selected[1], opts)
                vim.fn.setreg('+', file.path)
              end,
              reload = true,
            },
            ['ctrl-r'] = { -- TODO: no cursor
              fn = function(...) require('fzf-lua-overlay').actions.file_rename(...) end,
              reload = true,
            },
            ['ctrl-o'] = { -- call back?
              fn = function(selected, opts)
                for _, sel in ipairs(selected) do
                  local file = require('fzf-lua').path.entry_to_file(sel, opts)
                  -- TODO: should be on_exit...
                  vim.schedule_wrap(function() vim.cmd.e(file.path) end)
                end
              end,
            },
          },
        },
      },
    },
  },
}
