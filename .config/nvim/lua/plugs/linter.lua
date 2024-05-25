return {
  {
    'mfussenegger/nvim-lint',
    -- enabled = false,
    config = function()
      require('lint').linters_by_ft = {
        python = { 'pylint' },
      }

      au({
        'BufReadPost',
        'BufWritePost',
        'InsertLeave',
      }, {
        desc = 'Lint',
        callback = function() require('lint').try_lint() end,
      })
    end,
  },
}
