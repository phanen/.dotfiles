local target = fn.argv()[1]
local target_is_not_dir = not target or not fn.isdirectory(target)
return {
  'nvim-tree/nvim-tree.lua',
  lazy = target_is_not_dir,
  event = 'CmdlineEnter', -- :e dir
  cmd = 'NvimTreeFindFileToggle',
  keys = { 'gf' },
  opts = {
    sync_root_with_cwd = true,
    actions = { change_dir = { enable = true, global = true } },
    select_prompts = false,
    view = {
      width = {
        min = function() return math.max(math.floor(vim.go.columns), 25) end,
        max = function() return math.min(math.floor(vim.go.columns), 35) end,
      },
      adaptive_size = true,
    },
    -- hijack_directories = { enable = false },
    on_attach = function() end, -- don't do default keymap
  },
}
