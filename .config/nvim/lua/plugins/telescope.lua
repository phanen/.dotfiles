local reqcall = require("utils").reqcall
local mux = require("utils").mux

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
local help_tags = function() return tb.help_tags { default_text = getVisualSelection() } end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.2",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- { 'molecule-man/telescope-menufacture' },
      -- { 'natecraddock/telescope-zf-native.nvim' },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },

    cmd = "Telescope",
    keys = {
      { "<leader>ft",       toggle_cache_mode,       mode = { "n", "x" } },
      { "<leader>m",        tb.builtin,              mode = { "n", "x" } },
      { "<c-l>",            tb.find_files,           mode = { "n", "x" } },
      { "<c-b>",            tb.buffers,              mode = { "n", "x" } },
      { "<leader><tab>",    tb.colorscheme,          mode = { "n", "x" } },
      { "<leader><leader>", tb.resume,               mode = { "n", "x" } },
      -- { "<leader>j",        tb.oldfiles,             mode = { "n", "x" }, },
      { "<leader>h",        help_tags,               mode = { "n", "x" } },
      { "<leader>l",        live_grep,               mode = { "n", "x" } },
      { "<leader>/",        curbuf_fzf,              mode = { "n", "x" } },
      { "<leader>;",        tb.command_history,      mode = { "n", "x" } },
      { "<leader>fo",       tb.oldfiles,             mode = { "n", "x" } },
      { "<leader>fd",       tb.diagnostics,          mode = { "n", "x" } },
      { "<leader>fg",       tb.grep_string,          mode = { "n", "x" } },
      { "<leader>fk",       tb.keymaps,              mode = { "n", "x" } },
      { "<leader>fh",       tb.help_tags,            mode = { "n", "x" } },
      { "<leader>fu",       tb.resume,               mode = { "n", "x" } },
      { "<leader>fm",       tb.man_pages,            mode = { "n", "x" } },
      { "<leader>fs",       tb.lsp_document_symbols, mode = { "n", "x" } },
      { "<leader>fS",       tb.git_status,           mode = { "n", "x" } },
      { "<leader>fC",       tb.git_commits,          mode = { "n", "x" } },
      { "<leader>fB",       tb.git_bcommits,         mode = { "n", "x" } },
      { "<leader>f<tab>",   tb.colorscheme,          mode = { "n", "x" } },
      { "<leader>fq",       tb.quickfix,             mode = { "n", "x" } },
      { "z=",               tb.spell_suggest,        mode = { "n", "x" } },
      { "<leader>z",        tb.spell_suggest,        mode = { "n", "x" } },
      mode = { "n", "x" },
    },
    config = function()
      local tl = require "telescope"
      local ta = require "telescope.actions"
      local tag = require "telescope.actions.generate"
      local tas = require "telescope.actions.state"

      tl.setup {
        defaults = {
          file_ignore_patterns = {
            -- "!.*",
          },
          mappings = {
            i = {
              ["<c-u>"] = false,
              ["<c-d>"] = false,
              ["<c-v>"] = false,
              ["<esc>"] = ta.close,
              ["<c-j>"] = ta.move_selection_next,
              ["<c-k>"] = ta.move_selection_previous,
              ["<c-g>"] = ta.move_to_bottom,
              ["<c-y>"] = function(prompt_bufnr)
                local entry = tas.get_selected_entry()
                local prompt_text = entry.text or entry[1]
                vim.fn.system("echo -n " .. prompt_text .. "| xsel -ib")
                -- vim.api.nvim_paste(prompt_text, true, 1)
                --   vim.api.nvim_get_current_buf()
                ta.close(prompt_bufnr)
                return true -- otherwise, cannot close?
              end,
              ["<c-l>"] = function(prompt_bufnr)
                local entry = tas.get_selected_entry()
                local prompt_text = entry.text or entry[1]
                vim.fn.system("echo -n " .. prompt_text .. "| xsel -ib")
                vim.api.nvim_paste(prompt_text, true, 1)
                --   vim.api.nvim_get_current_buf()
                return true
              end,
              -- require('telescope.actions.state').get_current_picker(vim.api.nvim_buf_get_number(0))
              -- https://stackoverflow.com/questions/74091577/how-to-get-prompt-value-in-telescope-vim
              -- https://www.reddit.com/r/neovim/comments/11puvr6/getting_custom_telescope_live_grep_to_selectjump/

              -- https://github.com/nvim-telescope/telescope.nvim/issues/814
              ["<C-o>"] = function(prompt_bufnr)
                require("telescope.actions").select_default(prompt_bufnr)
                require("telescope.builtin").resume()
              end,
              ["<C-q>"] = ta.add_selected_to_qflist,
            },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, "fzf")
      pcall(tl.load_extension, "ui-select")
      -- pcall(tl.load_extension, "luasnip")
    end,
  },

  {
    "crispgm/telescope-heading.nvim",
    ft = { "markdown", "tex" },
    -- keys = { "<leader>fh", "<cmd>Telescope heading<cr>", desc = "find headings" },
  },

  {
    "benfowler/telescope-luasnip.nvim",
    cond = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() require("telescope").load_extension "luasnip" end,
  },
}
