local target = fn.argv()[1]
local target_is_not_dir = not target or not fn.isdirectory(target)
local fix_min = g.disable_icon and 10 or 15
local fix_max = g.disable_icon and 30 or 35
fix_min = 10
fix_max = 30
return {
  'nvim-tree/nvim-tree.lua',
  lazy = target_is_not_dir,
  event = 'CmdlineEnter', -- :e dir
  cmd = 'NvimTreeFindFileToggle',
  keys = { 'gf', 'gF', { '\r', 'gF' } },
  opts = {
    -- hijack_directories = { enable = true, auto_open = true },
    sync_root_with_cwd = true,
    actions = { change_dir = { enable = true, global = true } },
    select_prompts = false,
    view = {
      width = {
        min = function() return math.max(math.floor(0.1 * vim.go.columns), fix_min) end,
        max = function() return math.min(math.floor(0.2 * vim.go.columns), fix_max) end,
      },
      adaptive_size = true,
    },
    renderer = {
      -- indent_width = g.disable_icon and 0 or 1,
      indent_width = 2,
      indent_markers = {
        enable = true,
        icons = {
          -- corner = '└',
          corner = '│',
          edge = '│',
          item = '│',
          -- bottom = '─',
          bottom = '',
        },
      },
      icons = {
        show = {
          file = not g.disable_icon,
          folder = not g.disable_icon,
          folder_arrow = g.disable_icon,
          git = false,
          modified = false,
          hidden = false,
          diagnostics = false,
          bookmarks = true,
        },
      },
    },
    -- hijack_directories = { enable = false },
    on_attach = function() end, -- don't do default keymap
  },
}
