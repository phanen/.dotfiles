local used_method = "nvim-tree"

return {
  { -- no lazy load
    "nvim-tree/nvim-tree.lua",
    tag = "nightly",
    lazy = false,
    cond = used_method == "nvim-tree",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sync_root_with_cwd = true,
      view = {
        -- width = function() return 0.1 * vim.fn.winwidth(0) end,
        mappings = {
          custom_only = false,
          list = {
            { key = "l", action = "edit" },
            { key = "L", action = "cd" },
            { key = "H", action = "dir_up" },
            { key = "D", action = "toggle_dotfiles" },
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cond = used_method == "neo-tree",
    cmd = "Neotree",
    keys = {
      {
        "<leader>ne",
        function()
          require("neo-tree.command").execute {
            toggle = true,
            dir = require("utils").get_root(),
          }
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>nE",
        function() require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() } end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>e", "<leader>ne", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>E", "<leader>nE", desc = "Explorer NeoTree (cwd)",      remap = true },
    },
    deactivate = function() vim.cmd [[Neotree close]] end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then require "neo-tree" end
      end
    end,
    opts = {
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = true,
      },
      window = {
        mappings = {
          ["<space>"] = "none",
          ["-"] = "navigate_up",
          -- open file without losing focus
          ["<tab>"] = function(state)
            local node = state.tree:get_node()
            if require("neo-tree.utils").is_expandable(node) then
              state.commands["toggle_node"](state)
            else
              state.commands["open"](state)
              vim.cmd "Neotree reveal"
            end
          end,
          h = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" and node:is_expanded() then
              require("neo-tree.sources.filesystem").toggle_directory(state, node)
            else
              require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
            end
          end,
          l = function(state)
            local node = state.tree:get_node()
            if node.type == "directory" then
              if not node:is_expanded() then
                require("neo-tree.sources.filesystem").toggle_directory(state, node)
              elseif node:has_children() then
                require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
              end
            end
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
    },
  },
}
