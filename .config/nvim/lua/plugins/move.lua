local api, fn = vim.api, vim.fn

---Determine if a value of any type is empty
---@param item any
---@return boolean?
local function falsy(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'boolean' then return not item end
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

local function leap_keys()
  require('leap').leap({
    target_windows = vim.tbl_filter(
      function(win) return falsy(fn.win_gettype(win)) end,
      api.nvim_tabpage_list_wins(0)
    ),
  })
end

return {
  {
    'ggandor/leap.nvim',
    keys = { { 's', leap_keys, mode = 'n' } },
    opts = { equivalence_classes = { ' \t\r\n', '([{', ')]}', '`"\'' } },
  },
  {
    'ggandor/flit.nvim',
    keys = { 'f' },
    dependencies = { 'ggandor/leap.nvim' },
    opts = { labeled_modes = 'nvo', multiline = false },
  },

  -- {
  --   'ggandor/leap-spooky.nvim',
  --   -- keys = { 'd', 'c', 'y', 'gc' },
  --   lazy = false,
  --   config = true,
  -- --   opts = {
  -- --     affixes = {
  -- --       -- Mappings will be generated corresponding to all native text objects,
  -- --       -- like: (ir|ar|iR|aR|im|am|iM|aM){obj}.
  -- --
  -- --       -- Special line objects will also be added, by repeating the affixes.
  -- --       -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
  -- --       -- window.
  -- --
  -- --       -- The cursor moves to the targeted object, and stays there.
  -- --       magnetic = { window = 'm', cross_window = 'M' },
  -- --       -- The operation is executed seemingly remotely (the cursor boomerangs
  -- --       -- back afterwards).
  -- --       remote = { window = 'r', cross_window = 'R' },
  -- --     },
  -- --     -- If this option is set to true, the yanked text will automatically be pasted
  -- --     -- at the cursor position if the unnamed register is in use.
  -- --     paste_on_remote_yank = false,
  -- --   }
  -- }
  {
    "ggandor/leap-spooky.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = true,
    lazy = false,
  }
}
