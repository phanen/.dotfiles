local nmap = require("utils.keymaps").nmap
local vmap = require("utils.keymaps").vmap
local reqcall = require("utils").reqcall
-- local tel_ex = function(name) return require('telescope').extensions[name] end
-- local live_grep = function(_) tel_ex('menufacture').live_grep(opts) end
-- local find_files = function(opts) return tel_ex('menufacture').find_files(opts) end

-- local find_files = function(name)  return extensions('')/
-- local function dotfiles()
--   find_files({
--     prompt_title = 'dotfiles',
--     cwd = '',
--   })
-- end

local tl = reqcall "telescope"
local tb = reqcall "telescope.builtin"

local pick_curbuf = function()
  tb.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown { previewer = false })
end

-- https://vi.stackexchange.com/questions/467/how-can-i-clear-a-register-multiple-registers-completely
local function getVisualSelection()
  local save = vim.fn.getreg "t"
  vim.cmd [[noau normal! "ty]]
  local text = vim.fn.getreg "t"
  vim.fn.setreg("v", save)

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

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
      { "<c-l>",      tb.find_files,      mode = { "n", "x" }, desc = "pick files" },
      { "<leader>l",  tb.live_grep,       mode = { "n", "x" }, desc = "pick files" },
      { "<leader>/",  pick_curbuf,        mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fb", tb.buffers,         mode = { "n", "x" }, desc = "pick files" },
      { "<ctrl>b",    tb.buffers,         mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fo", tb.oldfiles,        mode = { "n", "x" }, desc = "pick files" },
      { "<leader>f;", tb.command_history, mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fw", tb.grep_string,     mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fd", tb.diagnostics,     mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fh", tb.help_tags,       mode = { "n", "x" }, desc = "pick files" },
      { "<leader>fm", tb.builtin,         mode = { "n", "x" }, desc = "pick files" },
    },
    config = function()
      local tl = require "telescope"
      local tb = require "telescope.builtin"
      local ta = require "telescope.actions"
      local ta = require "telescope.actions"

      tl.setup {
        defaults = {
          mappings = {
            i = {
              ["<c-u>"] = false,
              ["<c-d>"] = false,
              ["<esc>"] = ta.close,
              ["<a-/>"] = require("telescope.actions.generate").which_key {
                name_width = 20,           -- typically leads to smaller floats
                max_height = 0.5,          -- increase potential maximum height
                separator = " > ",         -- change sep between mode, keybind, and name
                close_with_action = false, -- do not close float on action
              },
            },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, "fzf")

      -- TODO: cache your search content
      -- TODO: fzf_lua really matters?

      -- nmap("<leader>e", ":Telescope current_buffer_fuzzy_find<cr>", opts)
      -- vmap("<leader>e", function()
      --   local text = vim.getVisualSelection()
      --   tb.current_buffer_fuzzy_find { default_text = text }
      -- end)
      --
      vmap("<leader>fk", function() tb.live_grep { default_text = getVisualSelection() } end)
      vmap("<leader>l", function() tb.live_grep { default_text = getVisualSelection() } end)
      nmap("<leader>l", tb.live_grep, { desc = "fzf grep" })
      --
      -- nmap("<leader><space>", tb.find_files, { desc = "fzf files" })
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
