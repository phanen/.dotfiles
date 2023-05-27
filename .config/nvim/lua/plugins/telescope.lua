local nnoremap = require('utils.keymaps').nnoremap
local vnoremap = require('utils.keymaps').vnoremap

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
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = {
      { 'nvim-lua/plenary.nvim', },
      -- { 'molecule-man/telescope-menufacture' },
      -- { 'natecraddock/telescope-zf-native.nvim' },
    },

    -- TODO: why
    -- 1. map leader to nop
    -- 2. add leader to keys
    -- then leader will be enable again...

    cmd = 'Telescope',
    keys = { '<leader><leader>', },
    config = function()
      local tl = require('telescope')
      local tb = require('telescope.builtin')

      tl.setup {
        defaults = {
          mappings = {
            i = { ['<c-u>'] = false, ['<c-d>'] = false, },
          },
        },
      }
      -- enable fzf native
      pcall(tl.load_extension, 'fzf')

      nnoremap('<leader>/', function()
        tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { previewer = false, }) end, { desc = 'fzf curbuf' }
      )
      nnoremap('<leader>fj', tb.find_files, { desc = 'fzf bufs' })
      nnoremap('<leader>fk', tb.live_grep, { desc = 'fzf grep' })
      nnoremap('<leader>fl', tb.buffers, { desc = 'fzf buffers' })
      -- nnoremap('<leader>f;;', tb, { desc = 'fzf files' })

      nnoremap('<leader>fb', tb.buffers, { desc = 'fzf bufs' })
      nnoremap('<leader>fr', tb.oldfiles, { desc = 'fzf recents' })
      nnoremap('<leader>ff', tb.find_files, { desc = 'fzf files' })
      nnoremap('<leader><space>', tb.find_files, { desc = 'fzf files' })
      nnoremap('<leader>:', tb.command_history, { desc = 'command' })
      nnoremap('<leader>fs', tb.live_grep, { desc = 'fzf grep' })
      nnoremap('<leader>fw', tb.grep_string, { desc = 'find word' })
      nnoremap('<leader>fd', tb.diagnostics, { desc = 'find diagnostics' })
      -- nnoremap('<leader>fh', "<cmd>Telescope heading<cr>", { desc = 'find headings' })
      nnoremap('<leader>fp', tb.help_tags, { desc = 'find help' })
      nnoremap('<leader>fm', tb.builtin, { desc = 'fnd meta' })

      function vim.getVisualSelection()
	vim.cmd('noau normal! "vy"')
	local text = vim.fn.getreg('v')
	vim.fn.setreg('v', {})

	text = string.gsub(text, "\n", "")
	if #text > 0 then
	  return text
	else
	  return ''
	end
      end

      -- TODO: cache your search content
      -- TODO: fzf_lua really matters?

      nnoremap('<space>e', ':Telescope current_buffer_fuzzy_find<cr>', opts)
      vnoremap('<space>e', function()
	local text = vim.getVisualSelection()
	tb.current_buffer_fuzzy_find({ default_text = text })
      end)

      -- nnoremap('<space>fj', ':Telescope live_grep<cr>', opts)
      vnoremap('<space>fj', function()
	local text = vim.getVisualSelection()
	tb.live_grep({ default_text = text })
      end)

    end,
  },

  {
    'crispgm/telescope-heading.nvim',
    ft = { 'markdown', 'tex', },
  }
}
