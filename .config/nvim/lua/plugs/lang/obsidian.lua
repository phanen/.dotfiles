return {
  'epwalsh/obsidian.nvim',
  cond = true,
  -- dependencies = { 'nvim-lua/plenary.nvim' },
  version = '*',
  -- init = function() vim.opt.conceallevel = 2 end,
  -- ft = 'markdown',
  event = {
    -- lazy.vim handle this by creating autocmd with `:h file-pattern`
    -- it's more like globbing rather than a regex...
    -- e.g. ~/notes/*.md include subdir, to fix it
    ('BufReadPre %s/notes/[^/]\\\\\\{1,30\\}.md'):format(fn.expand '~'),
    ('BufNewFile %s/notes/[^/]\\\\\\{1,30\\}.md'):format(fn.expand '~'),
  },
  cmd = {
    'ObsidianNew',
    'ObsidianToday',
    -- via external plugins
    'ObsidianOpen',
    'ObsidianTags',
    'ObsidianTOC',
  },
  keys = {
    { '+ob', '<cmd>ObsidianOpen<cr>' },
    { '+of', '<cmd>ObsidianTags<cr>' },
    { '+oq', '<cmd>ObsidianQuickSwitch<cr>' },
    { '+ot', '<cmd>ObsidianTOC<cr>' },
  },
  opts = {
    workspaces = {
      -- strict = true will spam on FileNotFoundError
      { name = 'notes', path = '~/notes', strict = false },
    },
    completion = { nvim_cmp = false, min_chars = 2 },
    mappings = {},
    follow_url_func = function(...) return vim.ui.open(...) end,
    disable_frontmatter = true,
    ---@return table
    note_frontmatter_func = function(note)
      -- Add the title of the note as an alias.
      if note.title then note:add_alias(note.title) end
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      -- `note.metadata` contains any manually added fields in the frontmatter.
      -- So here we just make sure those fields are kept in the frontmatter.
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    picker = {
      name = 'telescope.nvim',
      -- name = 'fzf-lua', -- TODO(upstream): no previewer
      mappings = { -- TODO: no support
        new = '<C-x>', -- Create a new note from your query.
        insert_link = '<C-l>', -- Insert a link to the selected note.
      },
    },
    ui = { enable = false },
  },
}
