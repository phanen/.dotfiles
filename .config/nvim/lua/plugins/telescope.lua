local reqcall = require("utils").reqcall
local mux = require("library").mux

local cache_flag = false
local sel_cache = ""

-- https://vi.stackexchange.com/questions/467/how-can-i-clear-a-register-multiple-registers-completely
local function getVisualSelection()
  -- NOTE: execute normal mode commands != enter into normal mode
  local reg_bak = vim.fn.getreg "v"

  -- HACK: <esc> just abort the normal mode pending
  vim.fn.setreg("v", {})
  vim.cmd [[noau normal! "vy\<esc\>]]

  local sel_text = vim.fn.getreg "v"
  vim.fn.setreg("v", reg_bak)

  -- normal mode
  if #sel_text == 0 then return mux(cache_flag, sel_cache, "") end

  -- visual mode
  sel_cache = string.gsub(sel_text, "\n", "")
  return sel_cache
end

local tb = reqcall "telescope.builtin"
local toggle_cache_mode = function() cache_flag = not cache_flag end

local curbuf_fzf = function()
  return tb.current_buffer_fuzzy_find { previewer = false, default_text = getVisualSelection() }
end
local live_grep = function() return tb.live_grep { default_text = getVisualSelection() } end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- { 'molecule-man/telescope-menufacture' },
      -- { 'natecraddock/telescope-zf-native.nvim' },
    },

    cmd = "Telescope",
    keys = {
      { "<leader>ft", toggle_cache_mode, mode = { "n", "x" }, desc = "pick files" },
      { "<c-l>", tb.find_files, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>l", live_grep, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>/", curbuf_fzf, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fb", tb.buffers, mode = { "n", "x" }, desc = "pick files" },
      { "<ctrl>b", tb.buffers, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fo", tb.oldfiles, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>;", tb.command_history, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fd", tb.diagnostics, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fh", tb.help_tags, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fm", tb.builtin, mode = { "n", "x" }, desc = "pick files" },
    },
    config = function()
      local tl = require "telescope"
      local ta = require "telescope.actions"
      local tag = require "telescope.actions.generate"

      tl.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-u>"] = false,
              ["<c-d>"] = false,
              ["<esc>"] = ta.close,
              ["<a-/>"] = tag.which_key {
                name_width = 20, -- typically leads to smaller floats
                max_height = 0.5, -- increase potential maximum height
                separator = " > ", -- change sep between mode, keybind, and name
                close_with_action = false, -- do not close float on action
              },
            },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, "fzf")
    end,
  },

  {
    "crispgm/telescope-heading.nvim",
    ft = { "markdown", "tex" },
    -- keys = { "<leader>fh", "<cmd>Telescope heading<cr>", desc = "find headings" },
  },

  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
}
