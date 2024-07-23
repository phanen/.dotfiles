-- local f = setmetatable({}, {
--   __index = function(_, k) return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k) end,
-- })

return {
  -- FIXME: fzf-lua fzf window colide with toggleterm <c-;>
  {
    'phanen/fzf-lua-overlay',
    cond = not vim.g.vscode,
    init = function() require('fzf-lua-overlay').init() end,
    -- stylua: ignore
    keys = function()
      local f = require('fzf-lua-overlay')
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
        { ' fc',        f.awesome_colorschemes,  mode = { 'n', 'x' } },
        { 'f<c-o>',     f.recentfiles,           mode = { 'n', 'x' } },
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
        { 'z=',         f.spell_suggest,         mode = { 'n', 'x' } },
        { ' fw',        f.lsp_workspace_symbols, mode = { 'n', 'x' } },
        { 'g<c-d>',     f.lsp_declarations,      mode = { 'n', 'x' } },
        { 'g<c-i>',     f.lsp_implementations,   mode = { 'n', 'x' } },
        { 'gd',         f.lsp_definitions,       mode = { 'n', 'x' } },
        { 'gh',         f.lsp_code_actions,      mode = { 'n', 'x' } },
        { 'gm',         f.lsp_typedefs,          mode = { 'n', 'x' } },
        { 'gr',         f.lsp_references,        mode = { 'n', 'x' } },
        { ' l',         f.find_dots,             mode = { 'n', 'x' } },
        { '+l',         f.grep_dots,             mode = { 'n', 'x' } },
      }
    end,
    opts = {},
  },
  {
    'ibhagwan/fzf-lua',
    cmd = {
      'Args',
      'Autocmd',
      'Buffers',
      'Changes',
      'Display',
      'F',
      'Files',
      'FzfLua',
      'Highlight',
      'Jumps',
      'Ls',
      'Marks',
      'Oldfiles',
      'Registers',
      'Tabs',
      'Tags',
    },
    config = function()
      local f = require('fzf-lua')
      local a = require('fzf-lua-overlay.actions')
      f.setup {
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
          man = { -- use man-db
            cmd = 'man %s | col -bx',
          },
        },
        winopts = { preview = { delay = 30 }, height = 0.6 },
        fzf_opts = {
          ['--history'] = vim.g.state_path .. '/telescope_history',
          ['--info'] = 'inline', -- easy to see count
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
          actions = {
            ['alt-n'] = a.file_create_open,
          },
          -- no_header = true,
          no_header_i = true,
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
            ['ctrl-s'] = { fn = f.actions.git_stage_unstage, reload = true },
            ['ctrl-x'] = { fn = f.actions.git_reset, reload = true },
          },
          },
        },
        helptags = {
          actions = {
            ['ctrl-o'] = {
              fn = a.file_edit_bg,
              -- using `reload = true` will fallback to `resume`
              resume = true,
            },
          },
        },
        oldfiles = {
          ['ctrl-o'] = {
            fn = a.file_edit_bg,
            resume = true,
          },
        },
        actions = {
          files = {
            ['default'] = f.actions.file_edit,
            ['ctrl-s'] = f.actions.file_edit_or_qf,
            -- ['ctrl-s'] = fzf.actions.file_sel_to_ll,
            ['alt-q'] = { fn = f.actions.file_sel_to_qf, prefix = 'select-all' },
            ['alt-s'] = {
              fn = function(sel) print('no items:', #sel) end,
              prefix = 'transform([ $FZF_SELECT_COUNT -eq 0 ] && echo select-all)',
            },
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
      require('lib.colors').set_fzf_lua_default_hlgroups()

      au('ColorScheme', {
        group = ag('FzfLuaSetDefaultHlgroups', {}),
        callback = require('lib.colors').set_fzf_lua_default_hlgroups,
      })

      local fzf_ls_cmd = {
        function(info)
          local suffix = string.format('%s %s', info.bang and '!' or '', info.args)
          return f.buffers {
            prompt = vim.trim(info.name .. suffix) .. '> ',
            ls_cmd = 'ls' .. suffix,
          }
        end,
        {
          bang = true,
          nargs = '?',
          complete = function()
            return { '+', '-', '=', 'a', 'u', 'h', 'x', '%', '#', 'R', 'F', 't' }
          end,
        },
      }

      ---Generate a completion function for user command that wraps a builtin command
      ---@param user_cmd string user command pattern
      ---@param builtin_cmd string builtin command
      ---@return fun(_, cmdline: string, cursorpos: integer): string[]
      local complfn = function(user_cmd, builtin_cmd)
        return function(_, cmdline, cursorpos)
          local cmdline_before = cmdline:sub(1, cursorpos):gsub(user_cmd, builtin_cmd, 1)
          return fn.getcompletion(cmdline_before, 'cmdline')
        end
      end

      local fzf_hi_cmd = {
        function(info)
          if vim.tbl_isempty(info.fargs) then
            f.highlights()
            return
          end
          if #info.fargs == 1 and info.fargs[1] ~= 'clear' then
            local hlgroup = info.fargs[1]
            if fn.hlexists(hlgroup) == 1 then
              vim.cmd.hi {
                args = { hlgroup },
                bang = info.bang,
              }
            else
              f.highlights {
                fzf_opts = {
                  ['--query'] = hlgroup,
                },
              }
            end
            return
          end
          vim.cmd.hi {
            args = info.fargs,
            bang = info.bang,
          }
        end,
        {
          bang = true,
          nargs = '*',
          complete = complfn('Highlight', 'hi'),
        },
      }

      local fzf_reg_cmd = {
        function(info)
          local query = table.concat(
            vim.tbl_map(
              function(reg) return string.format('^[%s]', reg:upper()) end,
              vim.split(info.args, '', {
                trimempty = true,
              })
            ),
            ' | '
          )
          f.registers {
            fzf_opts = {
              ['--query'] = query ~= '' and query or nil,
            },
          }
        end,
        {
          nargs = '*',
          complete = complfn('Registers', 'registers'),
        },
      }

      local fzf_display_cmd = vim.tbl_deep_extend('force', fzf_reg_cmd, {
        [2] = { complete = complfn('Display', 'display') },
      })

      local fzf_au_cmd = {
        function(info)
          if #info.fargs <= 1 and not info.bang then
            f.autocmds {
              fzf_opts = {
                ['--query'] = info.fargs[1] ~= '' and info.fargs[1] or nil,
              },
            }
            return
          end
          vim.cmd.autocmd {
            args = info.fargs,
            bang = info.bang,
          }
        end,
        {
          bang = true,
          nargs = '*',
          complete = complfn('Autocmd', 'autocmd'),
        },
      }

      local fzf_marks_cmd = {
        function(info)
          local query = table.concat(
            vim.tbl_map(
              function(mark) return '^' .. mark end,
              vim.split(info.args, '', {
                trimempty = true,
              })
            ),
            ' | '
          )
          f.marks {
            fzf_opts = {
              ['--query'] = query ~= '' and query or nil,
            },
          }
        end,
        {
          nargs = '*',
          complete = complfn('Marks', 'marks'),
        },
      }

      local fzf_args_cmd = {
        function(info)
          if not info.bang and vim.tbl_isempty(info.fargs) then
            f.args()
            return
          end
          vim.cmd.args {
            args = info.fargs,
            bang = info.bang,
          }
        end,
        {
          bang = true,
          nargs = '*',
          complete = complfn('Args', 'args'),
        },
      }

      cmd('Ls', unpack(fzf_ls_cmd))
      cmd('Args', unpack(fzf_args_cmd))
      cmd('Autocmd', unpack(fzf_au_cmd))
      cmd('Marks', unpack(fzf_marks_cmd))
      cmd('Highlight', unpack(fzf_hi_cmd))
      cmd('Registers', unpack(fzf_reg_cmd))
      cmd('Display', unpack(fzf_display_cmd))
      cmd('Oldfiles', f.oldfiles, {})
      cmd('Changes', f.changes, {})
      cmd('Tags', f.tagstack, {})
      cmd('Jumps', f.jumps, {})
      cmd('Tabs', f.tabs, {})
      cmd('Helptags', unpack(fzf_display_cmd))
    end,
  },

  {
    'tani/pickup.nvim',
    cond = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
  { -- https://github.com/junegunn/fzf.vim/issues/837
    'junegunn/fzf.vim',
    -- cond = not vim.g.vscode,
    cond = false,
    cmd = { 'Files', 'RG', 'Rg' },
    keys = {
      { ' <c-l>', '<cmd>Files<cr>', mode = { 'n', 'x' } },
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
