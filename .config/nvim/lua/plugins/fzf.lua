local fl = setmetatable({}, {
  __index = function(_, k)
    return function(opts)
      return function()
        local text = table.concat(util.getregion())
        local query_opt = text ~= '' and text or nil
        local _opts = {
          fzf_opts = {
            ['--query'] = query_opt,
            ['--history'] = vim.fn.stdpath 'state' .. '/telescope_history',
          },
        }
        require('fzf-lua')[k](vim.tbl_deep_extend('force', _opts, opts or {}))
      end
    end
  end,
})

local files =
  fl.files { cwd_prompt = false, git_icons = false, winopts = { preview = { hidden = 'hidden' } } }
local find_dots = fl.files { cwd = '~', winopts = { preview = { hidden = 'hidden' } } }
local grep_dots = fl.live_grep_native { cwd = '~' }

return {
  {
    'ibhagwan/fzf-lua',
    cmd = { 'FzfLua' },
    -- stylua: ignore
    keys = {
      { '<c-b>',      fl.buffers(),               mode = { 'n', 'x' } },
      { '<c-l>',      files,                      mode = { 'n', 'x' } },
      { '<c-n>',      fl.live_grep_native(),      mode = { 'n', 'x' } },
      { '<c-x><c-b>', fl.complete_bline(),        mode = 'i' },
      { '<c-x><c-f>', fl.complete_file(),         mode = 'i' },
      { '<c-x><c-p>', fl.complete_path(),         mode = 'i' },
      { '<leader>fa', fl.builtin(),               mode = { 'n', 'x' } },
      { '<leader>f/', fl.bline(),                 mode = { 'n', 'x' } },
      { '<leader>f;', fl.command_history(),       mode = { 'n', 'x' } },
      { '<leader>fh', fl.help_tags(),             mode = { 'n', 'x' } },
      { '<leader>fj', find_dots,                  mode = { 'n', 'x' } },
      { '<leader>ff', grep_dots,                  mode = { 'n', 'x' } },
      { '<leader> ',  fl.resume(),                mode = 'n' },
      { '<leader>fo', fl.oldfiles(),              mode = { 'n', 'x' } },
      { '<leader>fs', fl.lsp_document_symbols(),  mode = { 'n', 'x' } },
      { '<leader>fw', fl.lsp_workspace_symbols(), mode = { 'n', 'x' } },
      { '<leader>fr', fl.references(),            mode = { 'n', 'x' } },
    },
    opts = {
      winopts = { preview = { delay = 10 }, height = 0.6 },
      keymap = {
        builtin = {
          ['<c-\\>'] = 'toggle-preview',
          ['<c-d>'] = 'preview-page-down',
          ['<a-d>'] = 'deselect-all',
        },
        fzf = {},
      },
    },
  },
  {
    'rguruprakash/simple-note.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    cmd = { 'SimpleNoteList' },
    opts = {
      notes_dir = '~/notes/',
      telescope_new = '<c-n>',
      telescope_delete = '<c-x>',
      telescope_rename = '<c-r>',
    },
  },
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
    dependencies = { 'telescope.nvim', 'nvim-lua/plenary.nvim' },
    keys = { { '<leader>L', '<cmd>TodoTelescope<cr>' } },
    opts = { highlight = { keyword = 'bg' } },
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
            horizontal = { height = 0.5, preview_width = 0.55 },
            prompt_position = 'top',
          },
          file_ignore_patterns = { 'test', '.git', 'LICENSE', '*-lock.json' },
          mappings = {
            i = {
              ['<c-n>'] = ta.cycle_history_next,
              ['<c-p>'] = ta.cycle_history_prev,
              ['<c-u>'] = ta.preview_scrolling_up,
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
                vim.fn.system('echo -n ' .. prompt_text .. '| xsel -ib')
                vim.api.nvim_paste(prompt_text, true, 1)
                return true
              end,
              ['<c-o>'] = function(bufnr)
                ta.select_default(bufnr)
                require('telescope.builtin').resume()
              end,
              ['<c-q>'] = ta.add_selected_to_qflist,
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
