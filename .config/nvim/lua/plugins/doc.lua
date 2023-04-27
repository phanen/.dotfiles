return {
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    config = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      -- vim.g.mkdp_markdown_css = '/home/phanium/Downloads/typora-onedark-theme-1.10/theme/onedark_linux.css'
    end,
    ft = { 'markdown' },
  },

  { -- TODO lazy
    'askfiy/nvim-picgo',
    ft = { 'markdown' },
    config = function() require('nvim-picgo').setup() end
  },

  {
    'jakewvincent/mkdnflow.nvim',
    ft = { 'markdown' },
    config = function()
      require('mkdnflow').setup {
        mappings = {
          MkdnNextHeading = { 'n', ']]' },
          MkdnPrevHeading = { 'n', '[[' },
          MkdnNewListItemBelowInsert = { 'n', 'o' },
          MkdnNewListItemAboveInsert = { 'n', 'O' },
          MkdnCreateLinkFromClipboard = { { 'n', 'v' }, '<leader>p' }, -- see MkdnEnter
          MkdnEnter = false,
          MkdnTab = false,
          MkdnSTab = false,
          MkdnNextLink = false,
          MkdnPrevLink = false,
          MkdnGoBack = { 'n', '<BS>' },
          MkdnGoForward = { 'n', '<Del>' },
          MkdnCreateLink = false,                            -- see MkdnEnter
          MkdnFollowLink = false,                            -- see MkdnEnter
          MkdnDestroyLink = { 'n', '<M-CR>' },
          MkdnTagSpan = { 'v', '<M-CR>' },
          MkdnMoveSource = false,
          MkdnYankAnchorLink = { 'n', 'ya' },
          MkdnYankFileAnchorLink = { 'n', 'yfa' },
          MkdnIncreaseHeading = { 'n', '+' },
          MkdnDecreaseHeading = { 'n', '-' },
          MkdnToggleToDo = { { 'n', 'v' }, '<C-Space>' },
          MkdnNewListItem = false,
          MkdnExtendList = false,
          MkdnUpdateNumbering = { 'n', '<leader>nn' },
          MkdnTableNextCell = { 'i', '<Tab>' },
          MkdnTablePrevCell = { 'i', '<S-Tab>' },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { 'i', '<M-CR>' },
          MkdnTableNewRowBelow = { 'n', '<leader>ir' },
          MkdnTableNewRowAbove = { 'n', '<leader>iR' },
          MkdnTableNewColAfter = { 'n', '<leader>ic' },
          MkdnTableNewColBefore = { 'n', '<leader>iC' },
          MkdnFoldSection = { 'n', '<leader>f' },
          MkdnUnfoldSection = { 'n', '<leader>F' }
        }
      }
    end
  },

  -- latex
  {
    'f3fora/nvim-texlabconfig',
    cond = false,
    config = function() require('texlabconfig').setup() end,
    ft = { 'tex', 'bib' }, -- for lazy loading
    build = 'go build',
  },

  {
    'lervag/vimtex',
    cond = false,
  },

  -- math mode snippets
  {
    'iurimateus/luasnip-latex-snippets.nvim',
    cond = false,
    dependencies = { 'L3MON4D3/LuaSnip', 'lervag/vimtex' },
    config = function()
      require 'luasnip-latex-snippets'.setup({ use_treesitter = true })
    end,
    ft = { 'tex', 'markdown' },
  },
}
