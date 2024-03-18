local opts_fn = ...
local overlay = ...
local notes_actions = ...

local fl = setmetatable({}, {
  __index = function(_, k)
    return function()
      local opts, ropts, key, cmd
      key, opts, cmd = unpack(overlay[k])
      ropts = opts_fn(k)
      opts = vim.tbl_deep_extend('force', opts, ropts or {})
      if cmd then
        require('fzf-lua').fzf_exec(cmd, opts)
      else
        require('fzf-lua')[key](opts)
      end
    end
  end,
})

opts_fn = function(k)
  local text = table.concat(util.getregion())
  if k:match('grep') then
    return { search = text }
  else
    return { fzf_opts = { ['--query'] = text ~= '' and text or nil } }
  end
end

notes_actions = {
  ['ctrl-g'] = {
    function(_, opts)
      local o = opts.__call_opts
      if opts.show_daily_only then
        o.cmd = 'fd --color=never --type f --hidden --follow --exclude .git'
      else
        o.cmd = 'fd "[0-9][0-9]-[0-9][0-9]*"  --type f'
      end
      o.show_daily_only = not opts.show_daily_only
      opts.__call_fn(o)
    end,
  },
  ['ctrl-n'] = function(_, opts)
    local query = require('fzf-lua').get_last_query()
    if not query or query == '' then
      query = os.date('%m-%d')
    end
    local path = vim.fn.expand(fmt('%s/%s.md', opts.cwd, query))
    if not vim.uv.fs_stat(path) then
      local file = io.open(path, 'a')
      if not file then
        vim.notify(('fail to create file %s'):format(path))
        return
      end
      vim.notify(('%s has been created'):format(path))
      file:close()
    end
    vim.cmd.e(path)
  end,
  ['ctrl-x'] = {
    fn = function(selected, opts)
      -- TODO: multi?
      local cwd = opts.cwd or vim.fn.getcwd()
      local path = vim.fn.expand(('%s/%s'):format(cwd, selected[1]))
      local _fn, _opts = opts.__call_fn, opts.__call_opts
      require('fzf-lua').fzf_exec({ 'YES', 'NO' }, {
        prompt = ('Delete %s'):format(path),
        actions = {
          ['default'] = function(sel)
            if sel[1] == 'YES' and vim.uv.fs_stat(path) then
              vim.uv.fs_unlink(path)
              vim.notify(('%s has been deleted'):format(path))
            end
            _fn(_opts)
          end,
        },
      })
    end,
  },
}

overlay = setmetatable({
  find_dots = { 'files', { cwd = '~' } },
  live_grep_notes = { 'live_grep_native', { cwd = '~' } },
  todo_comment = { 'grep', { search = 'TODO|HACK|PERF|NOTE|FIX', no_esc = true } },
  lsp_references = {
    'lsp_references',
    { ignore_current_line = true, includeDeclaration = false },
  },
  find_notes = {
    'files',
    {
      cwd = '~/notes',
      actions = notes_actions,
      fzf_opts = {
        ['--history'] = vim.fn.stdpath 'state' .. '/fzf_notes_history',
      },
      file_icons = false,
      git_icons = false,
    },
  },
  zoxide = {
    'fzf_exec',
    {
      prompt = 'zoxide>',
      actions = {
        ['default'] = function(selected)
          local path = selected[1]:match('/.+')
          vim.api.nvim_set_current_dir(path)
        end,
      },
    },
    'zoxide query -ls',
  },
}, { -- other static opts lazy to write
  __index = function(t, k)
    local opts = {}
    if k:match('lsp') then
      opts.jump_to_single_result = true
    end
    local v = { k, opts }
    t[k] = v
    return v
  end,
})

return {
  {
    'junegunn/fzf.vim',
    cmd = { 'Files', 'RG', 'Rg' },
    dependencies = { 'junegunn/fzf' },
  },
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    -- stylua: ignore
    keys = {
      { '<c-b>',         fl.buffers,               mode = { 'n', 'x' } },
      { '<c-l>',         fl.files,                 mode = { 'n', 'x' } },
      { '<c-n>',         fl.live_grep_native,      mode = { 'n', 'x' } },
      { '<c-x><c-b>',    fl.complete_bline,        mode = 'i' },
      { '<c-x><c-f>',    fl.complete_file,         mode = 'i' },
      { '<c-x><c-p>',    fl.complete_path,         mode = 'i' },
      { 'gd',            fl.lsp_definitions,       mode = { 'n', 'x' } },
      { 'gh',            fl.lsp_code_actions,      mode = { 'n', 'x' } },
      { 'gr',            fl.lsp_references,        mode = { 'n', 'x' } },
      { '<leader><c-f>', fl.zoxide,                mode = { 'n', 'x' } },
      { '<leader><c-j>', fl.todo_comment,          mode = { 'n', 'x' } },
      { '<leader>e',     fl.find_notes,            mode = { 'n', 'x' } },
      { '<leader>fa',    fl.builtin,               mode = { 'n', 'x' } },
      { '<leader>f;',    fl.command_history,       mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags,             mode = { 'n', 'x' } },
      { '<leader>fj',    fl.live_grep_notes,       mode = { 'n', 'x' } },
      { '<leader>fk',    fl.keymaps,               mode = { 'n', 'x' } },
      { '<leader>/',     fl.blines,                mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume,                mode = 'n' },
      { '<leader>;',     fl.spell_suggest,         mode = { 'n', 'x' } },
      -- { '<leader>fo',    fl.oldfiles,              mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols,  mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_typedefs,          mode = { 'n', 'x' } },
      { '<leader>l',     fl.find_dots,             mode = { 'n', 'x' } },
    },
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
