local api, fn = vim.api, vim.fn
local used_method = "flash"

---Determine if a value of any type is empty
---@param item any
---@return boolean?
local function falsy(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == "boolean" then return not item end
  if item_type == "string" then return item == "" end
  if item_type == "number" then return item <= 0 end
  if item_type == "table" then return vim.tbl_isempty(item) end
  return item ~= nil
end

local function leap_keys()
  require("leap").leap {
    target_windows = vim.tbl_filter(function(win) return falsy(fn.win_gettype(win)) end, api.nvim_tabpage_list_wins(0)),
  }
end

return {
  {
    "ggandor/leap.nvim",
    cond = (used_method == "leap"),
    keys = { { "s", leap_keys, mode = "n" } },
    opts = { equivalence_classes = { " \t\r\n", "([{", ")]}", "`\"'" } },
    dependencies = "tpope/vim-repeat",
  },

  -- {
  --   'ggandor/flit.nvim',
  --   keys = { 'f' },
  --   dependencies = { 'ggandor/leap.nvim' },
  --   opts = { labeled_modes = 'nvo', multiline = false },
  -- },

  {
    "ggandor/leap-spooky.nvim",
    cond = (used_method == "leap"),
    dependencies = { "ggandor/leap.nvim" },
    config = true,
    lazy = false,
  },

  {
    "folke/flash.nvim",
    cond = (used_method == "flash"),
    event = "VeryLazy",
    ---@type Flash.Config
    -- cond = false,
    -- disable f F t T
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      { "s", mode = { "n", "o" }, function() require("flash").jump() end,       desc = "Flash", },
      { "f", mode = { "x" },      function() require("flash").jump() end,       desc = "Flash", },
      { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
      { "r", mode = "o",          function() require("flash").remote() end,     desc = "Remote Flash", },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Flash Treesitter Search",
      },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search", },
    },
  },
}
