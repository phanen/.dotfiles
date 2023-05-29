local nmap = require("utils.keymaps").nmap
local vmap = require("utils.keymaps").vmap

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

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.1",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      -- { 'molecule-man/telescope-menufacture' },
      -- { 'natecraddock/telescope-zf-native.nvim' },
    },

    -- TODO: why
    -- 1. map leader to nop
    -- 2. add leader to keys
    -- then leader will be enable again...

    cmd = "Telescope",
    keys = { "<leader><leader>" },
    config = function()
      local tl = require "telescope"
      local tb = require "telescope.builtin"

      tl.setup {
        defaults = {
          mappings = {
            i = { ["<c-u>"] = false, ["<c-d>"] = false },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, "fzf")

      nmap(
        "<leader>/",
        function() tb.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown { previewer = false }) end,
        { desc = "fzf curbuf" }
      )
      nmap("<leader>fj", tb.find_files, { desc = "fzf bufs" })
      nmap("<leader>fk", tb.live_grep, { desc = "fzf grep" })
      nmap("<leader>fl", tb.buffers, { desc = "fzf buffers" })
      -- nnoremap('<leader>f;;', tb, { desc = 'fzf files' })

      nmap("<leader>fb", tb.buffers, { desc = "fzf bufs" })
      nmap("<leader>fr", tb.oldfiles, { desc = "fzf recents" })
      nmap("<leader>ff", tb.find_files, { desc = "fzf files" })
      nmap("<leader>:", tb.command_history, { desc = "command" })
      nmap("<leader>fs", tb.live_grep, { desc = "fzf grep" })
      nmap("<leader>fw", tb.grep_string, { desc = "find word" })
      nmap("<leader>fd", tb.diagnostics, { desc = "find diagnostics" })
      -- nnoremap('<leader>fh', "<cmd>Telescope heading<cr>", { desc = 'find headings' })
      nmap("<leader>fp", tb.help_tags, { desc = "find help" })
      nmap("<leader>fm", tb.builtin, { desc = "fnd meta" })

      function vim.getVisualSelection()
        vim.cmd 'noau normal! "vy"'
        local text = vim.fn.getreg "v"
        vim.fn.setreg("v", {})

        text = string.gsub(text, "\n", "")
        if #text > 0 then
          return text
        else
          return ""
        end
      end

      -- TODO: cache your search content
      -- TODO: fzf_lua really matters?

      nmap("<leader>e", ":Telescope current_buffer_fuzzy_find<cr>", opts)
      vmap("<leader>e", function()
        local text = vim.getVisualSelection()
        tb.current_buffer_fuzzy_find { default_text = text }
      end)

      vmap("<leader>fk", function() tb.live_grep { default_text = vim.getVisualSelection() } end)

      nmap("<leader><space>", tb.find_files, { desc = "fzf files" })
      nmap("<leader>l", tb.live_grep, { desc = "fzf grep" })
    end,
  },

  {
    "crispgm/telescope-heading.nvim",
    ft = { "markdown", "tex" },
  },
}
