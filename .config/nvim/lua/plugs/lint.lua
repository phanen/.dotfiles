return {
  'mfussenegger/nvim-lint',
  event = 'BufWritePost',
  config = function()
    require('lint').linters_by_ft = {
      python = { 'pylint' },
      sh = { 'shellcheck' },
    }
    api.nvim_create_autocmd({
      'BufReadPost',
      'BufWritePost',
      'InsertLeave',
    }, {
      desc = 'Lint',
      callback = function() require('lint').try_lint() end,
    })
  end,
}
