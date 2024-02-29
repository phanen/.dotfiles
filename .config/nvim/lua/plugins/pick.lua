local pk = function(picker, opts)
  return function()
    local default = { previewer = picker == "live_grep", default_text = getvisual() }
    require("telescope.builtin")[picker](vim.tbl_deep_extend("force", default, opts or {}))
  end
end

local d = { "~", "~/notes" }

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
      { "<leader><leader>", pk("resume"),                           mode = { "n", "x" } },
      { "<leader>m",        pk("builtin"),                          mode = { "n", "x" } },
      { "<c-l>",            pk("find_files"),                       mode = { "n", "x" } },
      { "<leader>j",        pk("live_grep"),                        mode = { "n", "x" } },
      { "<localleader>+",   pk("find_files", { search_dirs = d }),  mode = { "n", "x" } },
      { "<localleader>_",   pk("live_grep", { search_dirs = d }),   mode = { "n", "x" } },
      { "<leader>/",        pk("current_buffer_fuzzy_find"),        mode = { "n", "x" } },
      { "<leader>;",        pk("command_history"),                  mode = { "n", "x" } },
      { "<leader>fo",       pk("oldfiles"),                         mode = { "n", "x" } },
      { "<leader>fh",       pk("help_tags"),                        mode = { "n", "x" } },
      { "<leader>fs",       pk("lsp_document_symbols"),             mode = { "n", "x" } },
      { "<leader>fg",       pk("git_status"),                       mode = { "n", "x" } },
      { "<leader>fc",       pk("git_commits"),                      mode = { "n", "x" } },
      { "<leader>f<tab>",   pk("colorscheme"),                      mode = { "n", "x" } },
      { "qj",               pk("spell_suggest"),                    mode = { "n", "x" } },
    },
    config = function()
      local ta = require "telescope.actions"
      local tas = require "telescope.actions.state"
      local tal = require "telescope.actions.layout"
      require("telescope").setup {
        defaults = {
          sorting_strategy = "ascending",
          preview = { hide_on_startup = true },
          layout_config = { horizontal = { height = 0.5, preview_width = 0.55 }, prompt_position = "top" },
          mappings = {
            i = {
              ["<c-n>"] = require("telescope.actions").cycle_history_next,
              ["<c-p>"] = require("telescope.actions").cycle_history_prev,
              ["<c-u>"] = ta.preview_scrolling_up,
              ["<c-d>"] = ta.preview_scrolling_down,
              ["<c-v>"] = false,
              ["<c-\\>"] = tal.toggle_preview,
              ["<esc>"] = ta.close,
              ["<c-j>"] = ta.move_selection_next,
              ["<c-k>"] = ta.move_selection_previous,
              ["<a-m>"] = tal.toggle_mirror,
              ["<a-p>"] = tal.cycle_layout_next,
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
                require("telescope.actions").select_default(bufnr)
                require("telescope.builtin").resume()
              end,
              ["<c-q>"] = ta.add_selected_to_qflist,
              ["<cr>"] = function(bufnr) -- TODO: need async!!!
                local picker = require("telescope.actions.state").get_current_picker(bufnr)
                local multi = picker:get_multi_selection()
                if not vim.tbl_isempty(multi) then
                  ta.close(bufnr)
                  for _, j in pairs(multi) do
                    if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
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
    "folke/todo-comments.nvim",
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = { { "<leader>L", "<cmd>TodoTelescope<cr>" } },
    opts = { highlight = { keyword = "bg" } },
  },
  {
    "junegunn/fzf.vim",
    cmd = { "Files" },
    keys = { { "<leader><c-l>", "<cmd>Files<cr>", mode = { "n", "x" } } },
    dependencies = { "junegunn/fzf", name = "fzf" },
  },
  {
    "ibhagwan/fzf-lua",
    cmd = { "FzfLua" },
    opts = {
      winopts = {
        preview = {
          border = "noborder",
          delay = 0,
          hidden = "hidden",
          horizontal = "right:55%",
          scrollbar = false,
        },
        height = 0.5,
        width = 0.8,
        row = 0.45,
        col = 0.5,
      },
    },
    keys = {
      { "<leader>ff", function() require("fzf-lua").files() end, desc = "Files" },
      { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Help tags" },
      { "<leader>fo", function() require("fzf-lua").oldfiles() end, desc = "Old files" },
      { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Symbols" },
      { "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Symbols" },
      { "<leader>fc", function() require("fzf-lua").colorschemes() end, desc = "Colorscheme" },
      { "<leader>fg", function() require("fzf-lua").live_grep_native() end, desc = "Live grep" },
    },
  },
}
