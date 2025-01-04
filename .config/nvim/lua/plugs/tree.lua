local target = fn.argv()[1]
local target_is_not_dir = not target or not fn.isdirectory(target)
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
        min = function() return math.max(math.floor(vim.go.columns), g.disable_icon and 20 or 25) end,
        max = function() return math.min(math.floor(vim.go.columns), g.disable_icon and 30 or 35) end,
      },
      adaptive_size = true,
    },
    renderer = {
      indent_width = g.disable_icon and 0 or 1,
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
