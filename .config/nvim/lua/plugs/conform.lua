return {
  'stevearc/conform.nvim',
  cmd = 'ConformInfo',
  opts = {
    formatters_by_ft = {
      fish = { 'fish_indent' },
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format' },
      dart = { 'dart_format' },
      sh = { 'shfmt', 'shellcheck' },
      xml = { 'xmlformat' },
      toml = { 'taplo' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      tex = { 'latexindent' },
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
      markdown = { 'injected' },
      help = { 'injected' },
    },
    formatters = {
      latexindent = { inherit = true, prepend_args = { '--GCString' } }, -- need perl-unicode-linebreak
    },
  },
}
