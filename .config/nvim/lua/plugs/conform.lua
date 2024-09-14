return {
  'stevearc/conform.nvim',
  cmd = 'ConformInfo',
  opts = {
    formatters_by_ft = {
      fish = { 'fish_indent', '--only-indent' },
      lua = { 'stylua' },
      python = { 'ruff' },
      sh = { 'shfmt', 'shellcheck' },
      xml = { 'xmlformat' },
      toml = { 'taplo' },
      -- c = { 'clang-format' },
      -- c = { 'uncrustify_nvim' },
      tex = { 'latexindent', '--GCString' }, -- for GCString feature, install `perl-unicode-linebreak` as extra dependency (for arch)
      bib = { 'bibtex-tidy' },
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      -- json = { 'prettier' }, -- not work?
      json = { 'clang-format' },
      less = { 'prettier' },
      scss = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      vue = { 'prettier' },
      yaml = { 'prettier' },
    },
    formatters = {
      uncrustify_nvim = {
        command = g.nvim_root .. '/build/usr/bin/uncrustify',
        args = function()
          local cfg = g.nvim_root .. '/src/uncrustify.cfg'
          return { '-q', '-l', 'C', '-c', cfg }
        end,
      },

      shfmt = {
        command = 'shfmt',
        args = function(_, ctx)
          local args = { '-filename', '$FILENAME' }
          local has_editorconfig = vim.fs.find(
            '.editorconfig',
            { path = ctx.dirname, upward = true }
          )[1] ~= nil

          -- If there is an editorconfig, don't pass any args because shfmt will apply settings from there
          -- when no command line args are passed.
          -- if not has_editorconfig and vim.bo[ctx.buf].expandtab then
          -- buggy?
          if vim.bo[ctx.buf].expandtab then vim.list_extend(args, { '-i', ctx.shiftwidth }) end
          return args
        end,
      },
    },
  },
}
