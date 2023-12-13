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

local find_files = function() return tb.find_files { previewer = false, default_text = getVisualSelection() } end
local live_grep = function() return tb.live_grep { previewer = true, default_text = getVisualSelection() } end
local buf_fzf = function() return tb.current_buffer_fuzzy_find { default_text = getVisualSelection() } end

local live_grep_ni = function() return tb.live_grep { no_ignore = true, default_text = getVisualSelection() } end
local find_files_ni = function() return tb.find_files { no_ignore = true, default_text = getVisualSelection() } end

local find_dots = function() tb.find_files { search_dirs = { "~" } } end
local find_notes = function() tb.find_files { search_dirs = { "~/notes" } } end
local grep_dots = function() tb.live_grep { search_dirs = { "~" } } end
local grep_notes = function() tb.live_grep { search_dirs = { "~/notes" } } end
local findme = function() tb.live_grep { search_dirs = { "~", "~/notes" } } end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- { 'molecule-man/telescope-menufacture' },
      -- { 'natecraddock/telescope-zf-native.nvim' },
      -- { "nvim-telescope/telescope-ui-select.nvim" },
      {
        "stevearc/dressing.nvim",
        init = function()
          ---@diagnostic disable-next-line: duplicate-set-field
          vim.ui.select = function(...)
            require("lazy").load { plugins = { "dressing.nvim" } }
            return vim.ui.select(...)
          end
        end,
        opts = {},
      },
    },

    cmd = "Telescope",
    keys = {
      { "<leader>ft",       toggle_cache_mode,       mode = { "n", "x" } },
      { "<leader><leader>", tb.resume,               mode = { "n", "x" } },
      { "<leader>m",        tb.builtin,              mode = { "n", "x" } },

      { "<c-l>",            find_files,              mode = { "n", "x" } },
      { "<leader>l",        live_grep,               mode = { "n", "x" } },
      { "<leader><c-l>",    find_files_ni,           mode = { "n", "x" } },
      { "<leader>fl",       live_grep_ni,            mode = { "n", "x" } },
      { "<leader>j",        tb.grep_string,          mode = { "n", "x" } },

      { "<leader>fj",       find_dots,               mode = { "n", "x" } },
      { "<leader>fk",       find_notes,              mode = { "n", "x" } },
      { "<leader>gj",       grep_dots,               mode = { "n", "x" } },
      { "<leader>gk",       grep_notes,              mode = { "n", "x" } },

      { "<c-b>",            tb.buffers,              mode = { "n", "x" } },
      { "<leader>;",        tb.command_history,      mode = { "n", "x" } },
      { "<leader>f/",       buf_fzf,                 mode = { "n", "x" } },
      { "<leader>fo",       tb.oldfiles,             mode = { "n", "x" } },
      -- { "<leader>fd",       tb.diagnostics,          mode = { "n", "x" } },
      { "<leader>fh",       tb.help_tags,            mode = { "n", "x" } },
      { "<leader>fm",       tb.man_pages,            mode = { "n", "x" } },
      { "<leader>fs",       tb.lsp_document_symbols, mode = { "n", "x" } },
      { "<leader>fS",       tb.git_status,           mode = { "n", "x" } },
      { "<leader>fC",       tb.git_commits,          mode = { "n", "x" } },
      { "<leader>fB",       tb.git_bcommits,         mode = { "n", "x" } },
      { "<leader>f<tab>",   tb.colorscheme,          mode = { "n", "x" } },
      { "<leader>fq",       tb.quickfix,             mode = { "n", "x" } },
      { "z=",               tb.spell_suggest,        mode = { "n", "x" } },
      -- { "<leader>z", tb.spell_suggest, mode = { "n", "x" } },
      mode = { "n", "x" },
    },
    config = function()
      local tl = require "telescope"
      local ta = require "telescope.actions"
      local tas = require "telescope.actions.state"
      local tal = require "telescope.actions.layout"

      tl.setup {
        defaults = {
          -- layout_strategy = "vertical",
          sorting_strategy = "ascending",
          path_display = {
            -- smart = true,
            -- shorten = { len = 1, exclude = { 1, -1 } },
          },
          preview = { hide_on_startup = true },
          layout_config = {
            horizontal = {
              height = 0.5,
              width = 0.8,
              preview_cutoff = 10,
              preview_width = 0.55,
              prompt_position = "top",
              -- mirror = true,
            },
            vertical = {
              prompt_position = "top",
            },
          },
          mappings = {
            i = {
              ["<c-u>"] = ta.preview_scrolling_up,
              ["<c-d>"] = ta.preview_scrolling_down,
              ["<c-v>"] = false,
              ["<c-g>"] = tal.toggle_preview,
              ["<c-n>"] = tal.toggle_mirror,
              ["<esc>"] = ta.close,
              ["<c-j>"] = ta.move_selection_next,
              ["<c-k>"] = ta.move_selection_previous,
              ["<c-p>"] = tal.cycle_layout_next,
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
              ["<c-o>"] = function(prompt_bufnr)
                require("telescope.actions").select_default(prompt_bufnr)
                require("telescope.builtin").resume()
              end,
              ["<c-q>"] = ta.add_selected_to_qflist,
            },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, "fzf")
      -- pcall(tl.load_extension, "ui-select")
      -- pcall(tl.load_extension, "luasnip")
    end,
  },

  {
    "benfowler/telescope-luasnip.nvim",
    cond = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() require("telescope").load_extension "luasnip" end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    cond = false,
    keys = { { "<leader>ff", "<cmd>Telescope file_browser<cr>" } },
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function() require("telescope").load_extension "file_browser" end,
  },

  -- faster
  {
    "junegunn/fzf.vim",
    lazy = false,
    -- cond = false,
    dependencies = { "junegunn/fzf", name = "fzf" },
  },
}
