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

      local s = ls.snippet
      local i = ls.insert_node
      local c = ls.choice_node
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta

      local informations = {
        username = "XXiaoA",
        email = "isxxiaoa@gmail.com",
      }

      --- Options for marks to be used in a TODO comment
      local marks = {
        function() return fmt("<{}>", i(1, os.date "%d-%m-%y")) end,
        function() return fmt("<{}>", i(1, informations.username)) end,
        function() return fmt("<{}{}>", { i(1, os.date "%d-%m-%y"), i(2, ", " .. informations.username) }) end,
        function() return fmt("<{}{}>", { i(1, informations.username), i(2, " " .. informations.email) }) end,
        function()
          return fmt("<{}{}{}>", {
            i(1, os.date "%d-%m-%y"),
            i(2, ", " .. informations.username),
            i(3, " " .. informations.email),
          })
        end,
      }

      local todo_snippet_nodes = function(aliases)
        local aliases_nodes = vim.tbl_map(function(alias)
          return i(nil, alias) -- generate choices for [name-of-comment]
        end, aliases)
        local sigmark_nodes = {} -- choices for [comment-mark]
        for _, mark in pairs(marks) do
          table.insert(sigmark_nodes, mark())
        end
        local format_strings = "<>: <>"
        -- format them into the actual snippet
        local comment_node = fmta(format_strings, {
          c(1, aliases_nodes), -- [name-of-comment]
          c(2, {
            i(1), -- {comment-text}
            fmta("<> <>", {
              i(2),
              c(1, sigmark_nodes), -- [comment-mark]
            }),
          }),
        })
        return comment_node
      end

      --- Generate a TODO comment snippet with an automatic description and docstring
      ---@param context table merged with the generated context table `trig` must be specified
      ---@param aliases string[] of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
      local function todo_snippet(context, aliases)
        context = context or {}
        if not context.trig then
          return error("context doesn't include a `trig` key which is mandatory", 2) -- all we need from the context is the trigger
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        local alias_string = table.concat(aliases, "|") -- `choice_node` documentation
        context.name = context.name or (alias_string .. " comment") -- generate the `name` of the snippet if not defined
        context.dscr = context.dscr or (alias_string .. " comment with a signature-mark") -- generate the `dscr` if not defined
        context.docstring = context.docstring or (" {1:" .. alias_string .. "}: {2}{0} ") -- generate the `docstring` if not defined
        local comment_node = todo_snippet_nodes(aliases) -- nodes from the previously defined function for their generation
        return s(context, comment_node) -- the final todo-snippet constructed from our parameters
      end

      local todo_snippet_specs = {
        { { trig = "todo" }, { "TODO" } },
        { { trig = "fix" }, { "FIX", "BUG", "ISSUE", "FIXIT" } },
        { { trig = "hack" }, { "HACK" } },
        { { trig = "warn" }, { "WARN", "WARNING", "XXX" } },
        { { trig = "perf" }, { "PERF", "PERFORMANCE", "OPTIM", "OPTIMIZE" } },
        { { trig = "note" }, { "NOTE", "INFO" } },
      }

      local todo_comment_snippets = {}
      for _, snippet in ipairs(todo_snippet_specs) do
        table.insert(todo_comment_snippets, todo_snippet(snippet[1], snippet[2]))
      end

      ls.add_snippets("commentable", todo_comment_snippets, { key = "todo_comments" })

      if vim.bo.ft ~= "gitcommit" then ls.filetype_extend(vim.bo.ft, { "commentable" }) end
      -- https://github.com/L3MON4D3/LuaSnip/issues/554
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function(ctx)
          if vim.bo[ctx.buf].ft ~= "gitcommit" then ls.filetype_extend(vim.bo[ctx.buf], { "commentable" }) end
        end,
      })
    end,
  },

  {
    "danymat/neogen",
    cmd = "Neogen",
    keys = { { "<leader>.", "<cmd>Neogen<CR>", desc = "Generate annotation" } },
    opts = { snippet_engine = "luasnip" },
  },
}
