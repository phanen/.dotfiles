local fl = setmetatable({}, {
  __index = function(_, k)
    return function()
      require('fzf-lua-overlay')[k]()
    end
  end,
})

return {
  {
    'phanen/fzf-lua-overlay',
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
      { '+fs',           fl.scriptnames,           mode = { 'n', 'x' } },
      { '+fr',           fl.rtp,                   mode = { 'n', 'x' } },
      { 'gd',            fl.lsp_definitions,       mode = { 'n', 'x' } },
      { 'gh',            fl.lsp_code_actions,      mode = { 'n', 'x' } },
      { 'gr',            fl.lsp_references,        mode = { 'n', 'x' } },
      { '<leader><c-f>', fl.zoxide,                mode = { 'n', 'x' } },
      { '<leader><c-j>', fl.todo_comment,          mode = { 'n', 'x' } },
      { '<leader>e',     fl.find_notes,            mode = { 'n', 'x' } },
      { '<leader>fa',    fl.builtin,               mode = { 'n', 'x' } },
      { '<leader>f;',    fl.command_history,       mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags,             mode = { 'n', 'x' } },
      { '<leader>fj',    fl.live_grep_dots,        mode = { 'n', 'x' } },
      { '<leader>fk',    fl.keymaps,               mode = { 'n', 'x' } },
      { '<leader>/',     fl.blines,                mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume,                mode = 'n' },
      { '<leader>;',     fl.spell_suggest,         mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols,  mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_typedefs,          mode = { 'n', 'x' } },
      { '<leader>l',     fl.find_dots,             mode = { 'n', 'x' } },
      { '+l',            fl.grep_dots,             mode = { 'n' } },
    },
    dependencies = { 'ibhagwan/fzf-lua' },
  },
  {
    'junegunn/fzf.vim',
    cmd = { 'Files', 'RG', 'Rg' },
    dependencies = { 'junegunn/fzf' },
  },
  {
    'ibhagwan/fzf-lua',
    -- branch = "1089",
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
          ['ctrl-r'] = function(...)
            require('fzf-lua').actions.toggle_ignore(...)
          end,
        },
      },
      actions = {
        files = {
          ['default'] = function(...)
            require('fzf-lua').actions.file_edit(...)
          end,
          ['ctrl-s'] = function(...)
            require('fzf-lua').actions.file_edit_or_qf(...)
          end,
          ['ctrl-y'] = {
            fn = function(selected)
              vim.fn.setreg('+', selected[1]:sub(7))
            end,
            reload = true,
          },
          ['ctrl-r'] = { -- TODO: no cursor
            fn = function(selected, opts)
              local file = require('fzf-lua').path.entry_to_file(selected[1], opts)
              local oldpath = file.path
              local oldname = vim.fs.basename(oldpath)
              local newname = vim.fn.input('New name: ', oldname)
              newname = vim.trim(newname)
              if newname == '' or newname == oldname then
                return
              end
              local cwd = opts.cwd or vim.fn.getcwd()
              local newpath = ('%s/%s'):format(cwd, newname)
              vim.uv.fs_rename(oldpath, newpath)
              vim.notify(
                ('%s has been renamed to %s'):format(oldpath, newpath),
                vim.log.levels.INFO
              )
            end,
            reload = true,
          },
          ['ctrl-o'] = { -- call back?
            fn = function(selected, opts)
              for _, sel in ipairs(selected) do
                local file = require('fzf-lua').path.entry_to_file(sel, opts)
                vim.schedule_wrap(function()
                  vim.cmd.e(file.path)
                end)
              end
            end,
          },
        },
      },
    },
  },
}
