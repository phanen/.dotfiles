local u = require('mod.winbar.utils')
local icons = u.static.icons
local M = {}

---@class winbar_configs_t
M.opts = {
  enable = function(buf, win)
    return vim.bo[buf].ft == 'fugitiveblame'
      or fn.win_gettype(win) == ''
        and vim.wo[win].winbar == ''
        and (vim.bo[buf].bt == '')
        and (pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft))
  end,
  update_interval = 32, -- cancel the previous update request
  icons = {
    kinds = {
      use_devicons = true,
      symbols = icons.kinds,
    },
    ui = {
      bar = {
        separator = vim.g.no_nf and ' > ' or icons.ui.AngleRight,
        extends = vim.opt.listchars:get().extends or vim.trim(icons.ui.Ellipsis),
      },
      menu = {
        separator = ' ',
        indicator = icons.ui.AngleRight,
      },
    },
  },
  symbol = {
    preview = {
      ---Reorient the preview window on previewing a new symbol
      ---@param _ integer source window id, ignored
      ---@param range {start: {line: integer}, end: {line: integer}} 0-indexed
      reorient = function(_, range)
        local invisible = range['end'].line - fn.line('w$') + 1
        if invisible > 0 then
          local view = fn.winsaveview()
          view.topline =
            math.min(view.topline + invisible, math.max(1, range.start.line - vim.wo.scrolloff + 1))
          fn.winrestview(view)
        end
      end,
    },
    jump = {
      ---@param win integer source window id
      ---@param range {start: {line: integer}, end: {line: integer}} 0-indexed
      reorient = function(win, range)
        local view = fn.winsaveview()
        local win_height = api.nvim_win_get_height(win)
        local topline = range.start.line - math.floor(win_height / 4)
        if topline > view.topline and topline + win_height < fn.line('$') then
          view.topline = topline
          fn.winrestview(view)
        end
      end,
    },
  },
  bar = {
    ---@type winbar_source_t[]|fun(buf: integer, win: integer): winbar_source_t[]
    sources = function(buf)
      local sources = require('mod.winbar.sources')
      return vim.bo[buf].ft == 'markdown'
          and {
            sources.path,
            sources.markdown,
          }
        or {
          sources.path,
          u.source.fallback {
            sources.lsp,
            sources.treesitter,
          },
        }
    end,
    padding = { left = 1, right = 0 },
    pick = {
      pivots = 'abcdefghijklmnopqrstuvwxyz',
    },
  },
  menu = {
    -- When on, preview the symbol in the source window
    preview = true,
    -- When on, set the cursor to the closest clickable component
    -- on CursorMoved
    quick_navigation = true,
    -- Menu scrollbar options
    scrollbar = {
      enable = true,
    },
    entry = {
      padding = {
        left = 1,
        right = 1,
      },
    },
    ---@type table<string, string|function|table<string, string|function>>
    keymaps = {
      ['q'] = function()
        local menu = u.menu.get_current()
        if menu then menu:close() end
      end,
      ['<LeftMouse>'] = function()
        local menu = u.menu.get_current()
        if not menu then return end
        local mouse = fn.getmousepos()
        local clicked_menu = u.menu.get { win = mouse.winid }
        -- If clicked on a menu, invoke the corresponding click action,
        -- else close all menus and set the cursor to the clicked window
        if clicked_menu then
          clicked_menu:click_at({ mouse.line, mouse.column - 1 }, nil, 1, 'l')
          return
        end
        u.menu.exec('close')
        u.bar.exec('update_current_context_hl')
        if api.nvim_win_is_valid(mouse.winid) then api.nvim_set_current_win(mouse.winid) end
      end,
      ['<CR>'] = function()
        local menu = u.menu.get_current()
        if not menu then return end
        local cursor = api.nvim_win_get_cursor(menu.win)
        local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
        if component then menu:click_on(component, nil, 1, 'l') end
      end,
      ['<MouseMove>'] = function()
        local menu = u.menu.get_current()
        if not menu then return end
        local mouse = fn.getmousepos()
        u.menu.update_hover_hl(mouse)
        if M.opts.menu.preview then u.menu.update_preview(mouse) end
      end,
    },
    ---@alias winbar_menu_win_config_opts_t any|fun(menu: winbar_menu_t):any
    ---@type table<string, winbar_menu_win_config_opts_t>
    ---@see vim.api.nvim_open_win
    win_configs = {
      border = 'none',
      style = 'minimal',
      relative = 'win',
      win = function(menu) return menu.prev_menu and menu.prev_menu.win or fn.getmousepos().winid end,
      row = function(menu)
        return menu.prev_menu
            and menu.prev_menu.clicked_at
            and menu.prev_menu.clicked_at[1] - fn.line('w0')
          or 0
      end,
      ---@param menu winbar_menu_t
      col = function(menu)
        if menu.prev_menu then
          return menu.prev_menu._win_configs.width + (menu.prev_menu.scrollbar and 1 or 0)
        end
        local mouse = fn.getmousepos()
        local bar = u.bar.get { win = menu.prev_win }
        if not bar then return mouse.wincol end
        local _, range = bar:get_component_at(math.max(0, mouse.wincol - 1))
        return range and range.start or mouse.wincol
      end,
      height = function(menu)
        return math.max(
          1,
          math.min(
            #menu.entries,
            vim.go.pumheight ~= 0 and vim.go.pumheight or math.ceil(vim.go.lines / 4)
          )
        )
      end,
      width = function(menu)
        local min_width = vim.go.pumwidth ~= 0 and vim.go.pumwidth or 8
        if vim.tbl_isempty(menu.entries) then return min_width end
        return math.max(
          min_width,
          math.max(
            unpack(vim.tbl_map(function(entry) return entry:displaywidth() end, menu.entries))
          )
        )
      end,
      zindex = function(menu)
        if menu.prev_menu then
          if menu.prev_menu.scrollbar and menu.prev_menu.scrollbar.thumb then
            return api.nvim_win_get_config(menu.prev_menu.scrollbar.thumb).zindex
          end
          return api.nvim_win_get_config(menu.prev_win).zindex
        end
      end,
    },
  },
  sources = {
    path = {
      ---@type string|fun(buf: integer, win: integer): string
      relative_to = function(_, win)
        -- Workaround for Vim:E5002: Cannot find window number
        local ok, cwd = pcall(fn.getcwd, win)
        return ok and cwd or fn.getcwd()
      end,
      ---Can be used to filter out files or directories
      ---based on their name
      ---@type fun(name: string): boolean
      filter = function(_) return true end,
      ---Last symbol from path source when current buf is modified
      ---@param sym winbar_symbol_t
      ---@return winbar_symbol_t
      modified = function(sym) return sym end,
    },
    treesitter = {
      -- Lua pattern used to extract a short name from the node text
      name_pattern = '[#~%*%w%._%->!@:]+%s*' .. string.rep('[#~%*%w%._%->!@:]*', 3, '%s*'),
      -- The order matters! The first match is used as the type
      -- of the treesitter symbol and used to show the icon
      -- Types listed below must have corresponding icons
      -- in the `icons.kinds.symbols` table for the icon to be shown
      valid_types = {
        'array',
        'boolean',
        'break_statement',
        'call',
        'case_statement',
        'class',
        'constant',
        'constructor',
        'continue_statement',
        'delete',
        'do_statement',
        'enum',
        'enum_member',
        'event',
        'for_statement',
        'function',
        'h1_marker',
        'h2_marker',
        'h3_marker',
        'h4_marker',
        'h5_marker',
        'h6_marker',
        'if_statement',
        'interface',
        'keyword',
        'list',
        'macro',
        'method',
        'module',
        'namespace',
        'null',
        'number',
        'operator',
        'package',
        'pair',
        'property',
        'reference',
        'repeat',
        'scope',
        'specifier',
        'string',
        'struct',
        'switch_statement',
        'type',
        'type_parameter',
        'unit',
        'value',
        'variable',
        'while_statement',
        'declaration',
        'field',
        'identifier',
        'object',
        'statement',
        'text',
      },
    },
    lsp = {
      request = {
        -- Times to retry a request before giving up
        ttl_init = 60,
        interval = 1000, -- in ms
      },
    },
    markdown = {
      parse = {
        -- Number of lines to update when cursor moves out of the parsed range
        look_ahead = 200,
      },
    },
  },
}

---@param opts winbar_configs_t?
M.set = function(opts) M.opts = vim.tbl_deep_extend('force', M.opts, opts or {}) end

-- FIXME: not complete annotation
---Evaluate a dynamic option value (with type T|fun(...): T)
---@generic T
---@param opts T|fun(...): T
---@return T
M.eval = function(opts, ...)
  if vim.is_callable(opts) then return opts(...) end
  return opts
end

return M
