-- local f = setmetatable({}, {
--   __index = function(_, k) return ([[<cmd>lua require('fzf-lua-overlay').%s()<cr>]]):format(k) end,
-- })

local f = r('fzf-lua-overlay')
return {
  -- FIXME: fzf-lua fzf window colide with toggleterm <c-;>
  {
    'phanen/fzf-lua-overlay',
    cond = not vim.g.vscode,
    init = function() require('fzf-lua-overlay').init() end,
    -- stylua: ignore
    keys = {
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
    },
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
          ['alt-n'] = function(...) require('fzf-lua-overlay.actions').file_create_open(...) end,
        },
        -- no_header = true,
        no_header_i = true,
      },
      grep = {
        file_icons = false,
        git_icons = false,
        -- no_header = true,
        no_header_i = true,
        -- de-dup followed?
        rg_opts = '-L --no-messages --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
        -- multiline = 0, -- fzf 0.53+
        actions = {
          ['ctrl-r'] = function(...) require('fzf-lua').actions.toggle_ignore(...) end,
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
            ['ctrl-s'] = { fn = function(...) require('fzf-lua').actions.git_stage_unstage(...) end, reload = true },
            ['ctrl-x'] = { fn = function(...) require('fzf-lua').actions.git_reset(...) end, reload = true },
          },
        },
      },
      helptags = {
        actions = {
          ['ctrl-o'] = {
            fn = function(...) require('fzf-lua-overlay.actions').file_edit_bg(...) end,
            reload = true,
          },
        },
      },
      actions = {
        files = {
          ['default'] = function(...) require('fzf-lua').actions.file_edit(...) end,
          ['ctrl-s'] = function(...) require('fzf-lua').actions.file_edit_or_qf(...) end,
          -- ['ctrl-s'] = function(...) require('fzf-lua').actions.file_sel_to_ll(...) end,
          ['ctrl-x'] = {
            fn = function(...) require('fzf-lua-overlay.actions').file_delete(...) end,
            reload = true,
          },
          ['ctrl-r'] = { -- TODO: cursor missed
            fn = function(...) require('fzf-lua-overlay.actions').file_rename(...) end,
            reload = true,
          },
          -- TODO: not work well in rg
          ['ctrl-o'] = {
            fn = function(...) require('fzf-lua-overlay.actions').file_edit_bg(...) end,
            reload = true,
          },
          ['ctrl-y'] = {
            fn = function(selected, opts)
              local paths = vim
                .iter(selected)
                :map(function(v) return require('fzf-lua').path.entry_to_file(v, opts).path end)
                :totable()
              fn.setreg('+', table.concat(paths, ' '))
            end,
            -- exec_silent = true,
          },
          ['ctrl-l'] = {
            fn = function()
              local fzf = require('fzf-lua')
              fzf.builtin {
                actions = {
                  ['default'] = function(selected)
                    fzf[selected[1]] {
                      query = fzf.config.__resume_data.last_query,
                      cwd = fzf.config.__resume_data.opts.cwd,
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
    },
    config = function(_, opts)
      local fzf = require('fzf-lua')
      fzf.setup(opts)
      require('lib.colors').set_fzf_lua_default_hlgroups()

      au('ColorScheme', {
        group = ag('FzfLuaSetDefaultHlgroups', {}),
        callback = require('lib.colors').set_fzf_lua_default_hlgroups,
      })

      local fzf_ls_cmd = {
        function(info)
          local suffix = string.format('%s %s', info.bang and '!' or '', info.args)
          return fzf.buffers({
            prompt = vim.trim(info.name .. suffix) .. '> ',
            ls_cmd = 'ls' .. suffix,
          })
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
            fzf.highlights()
            return
          end
          if #info.fargs == 1 and info.fargs[1] ~= 'clear' then
            local hlgroup = info.fargs[1]
            if fn.hlexists(hlgroup) == 1 then
              vim.cmd.hi({
                args = { hlgroup },
                bang = info.bang,
              })
            else
              fzf.highlights({
                fzf_opts = {
                  ['--query'] = hlgroup,
                },
              })
            end
            return
          end
          vim.cmd.hi({
            args = info.fargs,
            bang = info.bang,
          })
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
          fzf.registers({
            fzf_opts = {
              ['--query'] = query ~= '' and query or nil,
            },
          })
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
            fzf.autocmds({
              fzf_opts = {
                ['--query'] = info.fargs[1] ~= '' and info.fargs[1] or nil,
              },
            })
            return
          end
          vim.cmd.autocmd({
            args = info.fargs,
            bang = info.bang,
          })
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
          fzf.marks {
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
            fzf.args()
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
      -- cmd('Files', unpack(fzf_files_cmd))
      cmd('Args', unpack(fzf_args_cmd))
      cmd('Autocmd', unpack(fzf_au_cmd))
      cmd('Buffers', unpack(fzf_ls_cmd))
      cmd('Marks', unpack(fzf_marks_cmd))
      cmd('Highlight', unpack(fzf_hi_cmd))
      cmd('Registers', unpack(fzf_reg_cmd))
      cmd('Display', unpack(fzf_display_cmd))
      cmd('Oldfiles', fzf.oldfiles, {})
      cmd('Changes', fzf.changes, {})
      cmd('Tags', fzf.tagstack, {})
      cmd('Jumps', fzf.jumps, {})
      cmd('Tabs', fzf.tabs, {})
      cmd('Helptags', unpack(fzf_display_cmd))
    end,
  },
}
