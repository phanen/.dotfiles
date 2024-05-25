return {
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
    cmd = { 'Files', 'RG', 'Rg' },
    keys = {
      { '<leader><c-l>', '<cmd>Files<cr>', mode = { 'n', 'x' } },
      { '<leader><c-k>', '<cmd>Rg<cr>', mode = { 'n', 'x' } },
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
    cond = false,
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
