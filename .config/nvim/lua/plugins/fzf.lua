local opts_cb = function(k)
  local text = table.concat(util.getregion())
  local opts = {}
  if k:match('grep') then
    opts.search = text
    return opts
  end
  opts.fzf_opts = { ['--query'] = text ~= '' and text or nil }
  return opts
end

local notes_actions = {
  ['ctrl-n'] = function(_, opts)
    local query = require('fzf-lua').get_last_query()
    if query == '' then
      query = os.date('%m-%d')
    end
    local path = vim.fn.expand(fmt('%s/%s.md', opts.cwd, query))
    if not vim.uv.fs_stat(path) then
      local file = io.open(path, 'a')
      if file == nil then
        vim.notify('fzf-lua: fail to create file ' .. path)
        return
      end
      vim.notify(fmt('fzf-lua: %s has been created', path))
      file:close()
    end
    vim.cmd.e(path)
  end,
  ['ctrl-x'] = {
    fn = function(selected, opts)
      -- TODO: multi?
      local path = vim.fn.expand(fmt('%s/%s', opts.cwd, selected[1]))
      -- TODO: vim ui?
      local confirm = vim.fn.confirm(fmt('Delete %s', path), '&y\n&n')
      if confirm == 1 then
        if not vim.uv.fs_stat(path) then
          return nil
        end
        vim.uv.fs_unlink(path)
        -- vim.notify(path .. ' has been deleted')
      end
    end,
    reload = true,
  },
  ['ctrl-r'] = {
    fn = function(selected, opts)
      local filename = selected[1]
      local prefix = vim.fn.expand(opts.cwd)
      local path = fmt('%s/%s', prefix, filename)
      -- TODO: ignore ext name
      -- xx.xx, x.xx.xx, .xx, x.
      vim.split(filename, '.', { plain = true })
      local newname = vim.fn.input('New name: ', filename)
      local newpath = fmt('%s/%s', prefix, newname)
      if vim.trim(newpath) == '' then
        vim.notify('fzf-lua: empty name')
      end
      vim.uv.fs_rename(path, newpath)
      vim.notify(fmt('%s has been renamed to %s', path, newpath))
      -- require('fzf-lua').resume()
      -- TODO: vim ui
      -- TODO: missing cursor
      -- vim.ui.input({ prompt = 'New name:', default = filename }, function(newname)
      --   if newname == nil then
      --     return
      --   end
      -- end)
    end,
    reload = true,
  },
}

local overlay = {
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
      file_icons = false,
      git_icons = false,
    },
  },
  find_daily = {
    'files',
    {
      cmd = 'fd "[0-9][0-9]-[0-9][0-9]*"  --type f',
      cwd = '~/notes',
      actions = notes_actions,
      file_icons = false,
      git_icons = false,
    },
  },
}

---@module 'fzf-lua'
local fl = setmetatable({}, {
  __index = function(_, k)
    return function()
      local opts = opts_cb(k)
      local picker = k
      local preset = overlay[k]
      if preset then
        local old = opts
        picker, opts = unpack(preset)
        opts = vim.tbl_deep_extend('force', old, opts or {})
        if picker:match('lsp_') then
          opts.jump_to_single_result = true
        end
      end
      require('fzf-lua')[picker](opts)
    end
  end,
})

-- TODO: extend dir history to fzf-lua ver
-- since zoxide can not be hack into module, we can
local zoxide = function(opts)
  opts = opts or {}
  opts.prompt = 'zoxide> '
  local fzf_q = table.concat(util.getregion())
  opts.fzf_opts = {
    ['--query'] = fzf_q ~= '' and fzf_q or nil, -- fix injection
    ['--history'] = vim.fn.stdpath 'state' .. '/telescope_history',
  }
  opts.actions = {
    ['default'] = function(selected)
      local path = selected[1]:match('/.+')
      vim.api.nvim_set_current_dir(path)
    end,
  }
  require('fzf-lua').fzf_exec('zoxide query -ls', opts)
end

return {
  {
    'junegunn/fzf.vim',
    cmd = { 'Files', 'RG', 'Rg' },
    dependencies = { 'junegunn/fzf' },
    keys = {
      { '<leader><c-l>', '<cmd>Files<cr>', mode = { 'n', 'x' } },
      { '<leader><c-k>', '<cmd>Rg<cr>', mode = { 'n', 'x' } },
    },
  },
  {
    'phanen/fzf-lua-ext',
    dependencies = { 'ibhagwan/fzf-lua' },
    cond = false,
    -- stylua: ignore
    keys = {
      { '<leader><c-f>', function() require('fzf-lua-ext').zoxide() end,       mode = { 'n', 'x' } },
      { '<leader><c-j>', function() require('fzf-lua-ext').todo_comment() end, mode = { 'n', 'x' } },
      { '<leader>e',     function() require('fzf-lua-ext').find_notes() end,   mode = { 'n', 'x' } },
      { '<leader>fe',    function() require('fzf-lua-ext').find_daily() end,   mode = { 'n', 'x' } },
    },
  },
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    -- stylua: ignore
    keys = {
      { '<c-b>',         fl.buffers,                    mode = { 'n', 'x' } },
      { '<c-l>',         fl.files,                      mode = { 'n', 'x' } },
      { '<c-n>',         fl.live_grep_native,           mode = { 'n', 'x' } },
      { '<c-x><c-b>',    fl.complete_bline,             mode = 'i' },
      { '<c-x><c-f>',    fl.complete_file,              mode = 'i' },
      { '<c-x><c-p>',    fl.complete_path,              mode = 'i' },
      { 'gd',            fl.lsp_definitions,            mode = { 'n', 'x' } },
      { 'gh',            fl.lsp_code_actions,           mode = { 'n', 'x' } },
      { 'gr',            fl.lsp_references,             mode = { 'n', 'x' } },
      { '<leader><c-f>', zoxide,                        mode = { 'n', 'x' } },
      { '<leader><c-j>', fl.todo_comment,               mode = { 'n', 'x' } },
      { '<leader>e',     fl.find_notes,                 mode = { 'n', 'x' } },
      { '<leader>fa',    fl.builtin,                    mode = { 'n', 'x' } },
      { '<leader>fe',    fl.find_daily,                 mode = { 'n', 'x' } },
      { '<leader>f;',    fl.command_history,            mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags,                  mode = { 'n', 'x' } },
      { '<leader>fj',    fl.live_grep_notes,            mode = { 'n', 'x' } },
      { '<leader>fk',    fl.keymaps,                    mode = { 'n', 'x' } },
      { '<leader>/',     fl.blines,                     mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume,                     mode = 'n' },
      { '<leader>;',     fl.spell_suggest,              mode = { 'n', 'x' } },
      { '<leader>fo',    fl.oldfiles,                   mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols,       mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_workspace_symbols, mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_typedefs,               mode = { 'n', 'x' } },
      { '<leader>l',     fl.find_dots,                  mode = { 'n', 'x' } },
    },
    -- config = function(_, opts)
    --   require('fzf-lua').setup(opts or {})
    -- end,
    opts = {
      previewers = {
        builtin = {
          extensions = {
            -- TODO: neovim terminal only supports `viu` block output
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
          ['ctrl-l'] = {
            fn = function(selected)
              -- TODO: pattern match it
              vim.fn.setreg('+', selected[1]:sub(7))
            end,
            reload = true,
          },
          -- FIXME: unkown
          ['ctrl-o'] = {
            fn = function(...)
              require('fzf-lua').actions.file_edit_or_qf(...)
            end,
            reload = true,
          },
        },
      },
    },
  },
}
