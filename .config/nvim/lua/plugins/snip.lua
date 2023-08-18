return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require "luasnip"
      local types = require "luasnip.util.types"
      local extras = require "luasnip.extras"
      local fmt = require("luasnip.extras.fmt").fmt

      ls.config.set_config {
        -- history = false,
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Operator" } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { "●", "Type" } },
            },
          },
        },
        enable_autosnippets = true,
        snip_env = {
          fmt = fmt,
          m = extras.match,
          t = ls.text_node,
          f = ls.function_node,
          c = ls.choice_node,
          d = ls.dynamic_node,
          i = ls.insert_node,
          l = extras.lamda,
          snippet = ls.snippet,
        },
      }

      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = "./snippets" }
      ls.filetype_extend("all", { "_" })
    end,
  },

  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<leader>.", "<cmd>Neogen<CR>", desc = "Generate annotation" } },
    opts = { snippet_engine = "luasnip" },
  },
}
