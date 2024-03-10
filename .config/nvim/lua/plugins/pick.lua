local pk = function(picker, opts)
  return function()
    local default =
      { previewer = picker == "live_grep" or picker == "jumplist", default_text = table.concat(getvisual()) }
    require("telescope.builtin")[picker](vim.tbl_deep_extend("force", default, opts or {}))
  end
end

local d = { "~", "~/notes" }

local files = pk("fd", { hidden = true })
local grep_open_files = pk("live_grep", { grep_open_files = true })
local findx = pk("find_files", { hidden = true, search_dirs = d })
local grepx = pk("live_grep", { search_dirs = d })

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        config = function() require("telescope").load_extension "fzf" end,
      },
    },
    cmd = "Telescope",
    -- stylua: ignore
    keys = {
      { "<leader><leader>", pk("resume"),                mode = { "n", "x" } },
      { "<c-l>",            files,                       mode = { "n", "x" } },
      { "<c-n>",            pk("live_grep"),             mode = { "n", "x" } },
      { "<c-h>",            findx,                       mode = { "n", "x" } },
      { "<c-p>",            grepx,                       mode = { "n", "x" } },
      { "<c-b>",            pk("buffers"),               mode = { "n", "x" } },
      { "<leader>/",        grep_open_files,             mode = { "n", "x" } },
      { "<leader>;",        pk("command_history"),       mode = { "n", "x" } },
      { "<leader>j",        pk("jumplist"),              mode = { "n", "x" } },
      { "<leader>i",        pk("tagstack"),              mode = { "n", "x" } },
      { "<leader>fs",       pk("lsp_document_symbols"),  mode = { "n", "x" } },
      { "<leader>fw",       pk("lsp_workspace_symbols"), mode = { "n", "x" } },
      { "<leader>fa",       pk("builtin"),               mode = { "n", "x" } },
      { "<leader>fo",       pk("oldfiles"),              mode = { "n", "x" } },
      { "<leader>fh",       pk("help_tags"),             mode = { "n", "x" } },
      { "<leader>fg",       pk("git_status"),            mode = { "n", "x" } },
      { "<leader>fc",       pk("git_commits"),           mode = { "n", "x" } },
      { "<leader>f<tab>",   pk("colorscheme"),           mode = { "n", "x" } },
      { "qj",               pk("spell_suggest"),         mode = { "n", "x" } },
    },
    config = function()
      local ta = require "telescope.actions"
      local tas = require "telescope.actions.state"
      local tal = require "telescope.actions.layout"
      require("telescope").setup {
        defaults = {
          sorting_strategy = "ascending",
          preview = { hide_on_startup = true },
          -- FIXME: vertical no preview
          layout_config = { horizontal = { width = 0.85, height = 0.5, preview_width = 0.55 }, prompt_position = "top" },
          file_ignore_patterns = { "LICENSE", "*-lock.json" },
          mappings = {
            i = {
              ["<c-n>"] = ta.cycle_history_next,
              ["<c-p>"] = ta.cycle_history_prev,
              ["<c-u>"] = ta.preview_scrolling_up,
              ["<c-d>"] = ta.preview_scrolling_down,
              ["<c-v>"] = false,
              ["<c-\\>"] = tal.toggle_preview,
              ["<esc>"] = ta.close,
              ["<c-j>"] = ta.move_selection_next,
              ["<c-k>"] = ta.move_selection_previous,
              ["<a-m>"] = tal.toggle_mirror,
              ["<a-p>"] = tal.cycle_layout_prev,
              ["<a-n>"] = tal.cycle_layout_next,
              ["<c-l>"] = function(_)
                local entry = tas.get_selected_entry()
                if entry == nil then return true end
                local prompt_text = entry.text or entry[1]
                vim.fn.system("echo -n " .. prompt_text .. "| xsel -ib")
                vim.api.nvim_paste(prompt_text, true, 1)
                return true
              end,
              ["<c-o>"] = function(bufnr)
                ta.select_default(bufnr)
                require("telescope.builtin").resume()
              end,
              ["<c-q>"] = ta.add_selected_to_qflist,
              ["<cr>"] = function(bufnr) -- TODO: need async!!!
                local picker = tas.get_current_picker(bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                  ta.close(bufnr)
                  for _, j in pairs(multi) do
                    if j.path ~= nil then vim.cmd(fmt("%s %s", "edit", j.path)) end
                  end
                else
                  ta.select_default(bufnr)
                end
              end,
            },
          },
        },
      }
    end,
  },
  {
    "rguruprakash/simple-note.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "SimpleNoteList" },
    config = function()
      require("simple-note").setup {
        notes_dir = "~/notes/",
        telescope_new = "<c-n>",
        telescope_delete = "<c-x>",
        telescope_rename = "<c-r>",
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = { { "<leader>L", "<cmd>TodoTelescope<cr>" } },
    opts = { highlight = { keyword = "bg" } },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    opts = {
      hls = {
        normal = "NormalFloat",
        border = "FloatBorder",
        title = "FloatTitle",
        preview_normal = "NormalFloat",
        preview_border = "FloatBorder",
        preview_title = "FloatTitle",
      },
      fzf_colors = {
        ["fg"] = { "fg", "CursorLine" },
        ["bg"] = { "bg", "NormalFloat" },
        ["hl"] = { "fg", "Statement" },
        ["fg+"] = { "fg", "NormalFloat" },
        ["bg+"] = { "bg", "CursorLine" },
        ["hl+"] = { "fg", "Statement" },
        ["info"] = { "fg", "PreProc" },
        ["prompt"] = { "fg", "Conditional" },
        ["pointer"] = { "fg", "Exception" },
        ["marker"] = { "fg", "Keyword" },
        ["spinner"] = { "fg", "Label" },
        ["header"] = { "fg", "Comment" },
        ["gutter"] = { "bg", "NormalFloat" },
      },
      winopts = {
        preview = {
          border = "noborder",
          delay = 0,
          hidden = "nohidden",
          horizontal = "right:55%",
          scrollbar = false,
        },
        height = 0.5,
        width = 0.9,
      },
      keymap = {
        builtin = {
          ["<c-\\>"] = "toggle-preview",
          ["<c-_>"] = "toggle-preview",
          ["<c-d>"] = "preview-page-down",
          ["<c-u>"] = "preview-page-up",
          ["<a-s>"] = "select-all",
          ["<a-d>"] = "deselect-all",
        },
      },
    },
    keys = { { "<localleader>fa", "<cmd>FzfLua<cr>", mode = { "n", "x" } } },
  },
}
