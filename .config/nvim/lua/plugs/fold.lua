return {
  {
    'kevinhwang91/nvim-ufo',
    cond = false,
    -- event = { 'BufRead', '' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = 'kevinhwang91/promise-async',
    init = function()
      local set_foldcolumn_for_file = ag('set_foldcolumn_for_file', {
        clear = true,
      })
      autocmd({ 'BufRead', 'BufNewFile' }, {
        group = set_foldcolumn_for_file,
        callback = function()
          if vim.bo.buftype == '' then
            vim.wo.foldcolumn = '1'
          else
            vim.wo.foldcolumn = '0'
          end
        end,
      })
      autocmd('OptionSet', {
        group = set_foldcolumn_for_file,
        pattern = 'buftype',
        callback = function()
          if vim.bo.buftype == '' then
            vim.wo.foldcolumn = '1'
          else
            vim.wo.foldcolumn = '0'
          end
        end,
      })
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = { close_fold_kinds_for_ft = { default = { 'imports' } } },
    config = function(_, opts)
      local ufo = require 'ufo'
      ufo.setup(opts)
      autocmd('LspAttach', {
        callback = function(args)
          map.n('_', function()
            local winid = ufo.peekFoldedLinesUnderCursor()
            if not winid then vim.lsp.buf.hover() end
          end, { buffer = args.buf })
        end,
      })
    end,
  },
}
