local fl = setmetatable({}, {
  __index = function(_, k)
    return function(opts)
      return function()
        local text = table.concat(util.getregion())
        local fzf_q, rg_q
        if k:match('grep') then
          fzf_q, rg_q = nil, text
        else
          fzf_q, rg_q = text, nil
        end
        local _opts = {
          search = rg_q,
          fzf_opts = {
            ['--query'] = fzf_q ~= '' and fzf_q or nil, -- fix injection
            ['--history'] = vim.fn.stdpath 'state' .. '/telescope_history',
          },
        }
        if k:match('lsp_') then
          _opts['jump_to_single_result'] = true
        end
        require('fzf-lua')[k](vim.tbl_deep_extend('force', _opts, opts or {}))
      end
    end
  end,
})

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

local find_notes = fl.files {
  cwd = '~/notes',
  file_icons = false,
  git_icons = false,
  actions = notes_actions,
}

-- TODO: should jump if only one result?
local find_daily = fl.files {
  cwd = '~/notes',
  cmd = 'fd "[0-9][0-9]-[0-9][0-9]*"  --type f',
  file_icons = false,
  git_icons = false,
  actions = notes_actions,
}

return {
  {
    'junegunn/fzf.vim',
    cmd = { 'Files', 'RG', 'Rg' },
    dependencies = { 'junegunn/fzf' },
    keys = {
      { '<leader><c-l>', '<cmd>Files<cr>', mode = { 'n', 'x' } },
      { '<leader><c-k>', '<cmd>Rg<cr>', mode = { 'n', 'x' } },
      -- { '<leader><c-j>', '<cmd>RgD -path=~/notes -pattern=<cr>', mode = { 'n', 'x' } },
    },
  },
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    -- stylua: ignore
    keys = {
      { '<c-b>',         fl.buffers(),                            mode = { 'n', 'x' } },
      { '<c-l>',         fl.files(),                              mode = { 'n', 'x' } },
      { '<c-n>',         fl.live_grep_native(),                   mode = { 'n', 'x' } },
      { '<c-x><c-b>',    fl.complete_bline(),                     mode = 'i' },
      { '<c-x><c-f>',    fl.complete_file(),                      mode = 'i' },
      { '<c-x><c-p>',    fl.complete_path(),                      mode = 'i' },
      { 'gd',            fl.lsp_definitions(),                    mode = { 'n', 'x' } },
      { 'gh',            fl.lsp_code_actions(),                   mode = { 'n', 'x' } },
      { 'gr',            fl.lsp_references(),                     mode = { 'n', 'x' } },
      { '<leader><c-j>', fl.live_grep_native { cwd = "~/notes" }, mode = { 'n', 'x' } },
      { '<leader>e',     find_daily,                              mode = { 'n', 'x' } },
      { '<leader>fa',    fl.builtin(),                            mode = { 'n', 'x' } },
      { '<leader>f/',    fl.bline(),                              mode = { 'n', 'x' } },
      { '<leader>f;',    fl.command_history(),                    mode = { 'n', 'x' } },
      { '<leader>fh',    fl.help_tags(),                          mode = { 'n', 'x' } },
      { '<leader> ',     fl.resume(),                             mode = 'n' },
      { '<leader>fe',    find_notes,                              mode = { 'n', 'x' } },
      { '<leader>fo',    fl.oldfiles(),                           mode = { 'n', 'x' } },
      { '<leader>fs',    fl.lsp_document_symbols(),               mode = { 'n', 'x' } },
      { '<leader>fw',    fl.lsp_live_workspace_symbols(),         mode = { 'n', 'x' } },
      { '<leader>gd',    fl.lsp_type_definitions(),               mode = { 'n', 'x' } },
      { '<leader>l',     fl.files { cwd = '~' },                  mode = { 'n', 'x' } },
    },
    opts = {
      winopts = { preview = { delay = 50 }, height = 0.6 },
      keymap = {
        builtin = {
          ['<c-\\>'] = 'toggle-preview',
          ['<c-d>'] = 'preview-page-down',
          ['<a-d>'] = 'deselect-all',
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
          ['ctrl-l'] = function(selected)
            -- TODO: pattern match it
            -- TODO: retrigger
            vim.fn.setreg('+', selected[1]:sub(7))
          end,
        },
        lsp = {
          -- FIXME: not valid
          -- jump_to_single_result = true,
        },
      },
    },
  },
  -- TODO: fzf-lua zoxide
  -- TODO: don't open buffer?
  {
    'lexay/telescope-zoxide.nvim',
    keys = {
      {
        '<leader><c-f>',
        function()
          require('telescope')
            .load_extension('zoxide')
            .zoxide { default_text = table.concat(util.getregion()) }
        end,
        mode = { 'n', 'x' },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    keys = { { '<leader>fj', '<cmd>TodoTelescope<cr>' } },
    opts = true,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function()
          require('telescope').load_extension 'fzf'
        end,
      },
    },
    cmd = 'Telescope',
    keys = {
      { '<leader>fb', '<cmd>Telescope builtin<cr>' },
    },
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
                if entry == nil then
                  return true
                end
                local prompt_text = entry.text or entry[1]
                vim.fn.setreg('+', prompt_text)
                vim.api.nvim_paste(prompt_text, true, 1)
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
                  vim.iter(multi):each(function(v)
                    vim.cmd.e(v.path)
                  end)
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
