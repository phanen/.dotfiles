local req = require("utils").reqcall
local tb = req "telescope.builtin"
local ta = req "telescope.actions"
local tas = req "telescope.actions.state"
local tal = req "telescope.actions.layout"

local use_cache = false
local toggle_cache = function() use_cache = not use_cache end

local get_cache = function()
  local cache_str = ""
  local sel_text = require("utils").get_visual():gsub("\n", "")
  -- for visual
  if #sel_text ~= 0 then
    cache_str = sel_text
    return cache_str
  end
  -- for normal
  if use_cache then return cache_str end
  return ""
end

-- picker with extended options
local pk = function(picker, opts)
  return function()
    local default = { previewer = picker == tb.live_grep, default_text = get_cache() }
    picker(vim.tbl_deep_extend("force", default, opts or {}))
  end
end

-- picker on dir, prefer node path
local pn = function(picker, dirs)
  local node_path_dir = function()
    local node = require("nvim-tree.api").tree.get_node_under_cursor()
    if not node then return end
    if node.parent and node.type == "file" then return node.parent.absolute_path end
    return node.absolute_path
  end
  return function()
    local ndir = nil
    local ft = vim.api.nvim_get_option_value("filetype", {})
    if ft == "NvimTree" then ndir = node_path_dir() end
    picker {
      search_dirs = ndir and { ndir } or dirs,
      previewer = picker == tb.live_grep,
      -- default_text = get_cache(),
    }
  end
end

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
      { "<leader>ft",       toggle_cache,                            mode = { "n", "x" } },
      { "<leader><leader>", tb.resume,                               mode = { "n", "x" } },
      { "<leader>m",        pk(tb.builtin),                          mode = { "n", "x" } },
      { "<c-l>",            pk(tb.find_files),                       mode = { "n", "x" } },
      { "<leader>j",        pk(tb.live_grep),                        mode = { "n", "x" } },
      -- TODO: toggle ignore w
      { "<leader><c-l>",    pk(tb.find_files, { no_ignore = true }), mode = { "n", "x" } },
      { "<leader>fl",       pk(tb.live_grep, { no_ignore = true }),  mode = { "n", "x" } },
      { "<localleader>+",   pn(tb.find_files, { "~", "~/notes" }),   mode = { "n", "x" } },
      { "<localleader>o",   pn(tb.live_grep, { "~", "~/notes" }),    mode = { "n", "x" } },
      { "<leader>/",        pk(tb.current_buffer_fuzzy_find),        mode = { "n", "x" } },
      { "<leader>;",        pk(tb.command_history),                  mode = { "n", "x" } },
      { "<leader>fo",       pk(tb.oldfiles),                         mode = { "n", "x" } },
      { "<leader>fh",       pk(tb.help_tags),                        mode = { "n", "x" } },
      { "<leader>fs",       pk(tb.lsp_document_symbols),             mode = { "n", "x" } },
      { "<leader>fg",       pk(tb.git_status),                       mode = { "n", "x" } },
      { "<leader>fc",       pk(tb.git_commits),                      mode = { "n", "x" } },
      { "<leader>f<tab>",   pk(tb.colorscheme),                      mode = { "n", "x" } },
      { "zj",               pk(tb.spell_suggest),                    mode = { "n", "x" } },
    },
    opts = {
      defaults = {
        sorting_strategy = "ascending",
        preview = { hide_on_startup = true },
        layout_config = { horizontal = { height = 0.5, preview_width = 0.55 }, prompt_position = "top" },
        mappings = {
          i = {
            ["<c-u>"] = ta.preview_scrolling_up,
            ["<c-d>"] = ta.preview_scrolling_down,
            ["<c-v>"] = false,
            ["<c-\\>"] = tal.toggle_preview,
            ["<c-p>"] = tal.toggle_mirror,
            ["<esc>"] = ta.close,
            ["<c-j>"] = ta.move_selection_next,
            ["<c-k>"] = ta.move_selection_previous,
            ["<c-n>"] = tal.cycle_layout_next,
            ["<c-l>"] = function(_)
              local entry = tas.get_selected_entry()
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
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
    keys = { { "<leader>L", "<cmd>TodoTelescope<cr>" } },
    opts = { highlight = { keyword = "bg" } },
  },
  { "junegunn/fzf.vim", cmd = { "Files" }, dependencies = { "junegunn/fzf", name = "fzf" } },
}