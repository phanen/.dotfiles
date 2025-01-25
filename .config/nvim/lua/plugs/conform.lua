local ft_opts = {
  fish = { 'fish_indent' },
  lua = { 'stylua' },
  python = { 'ruff_fix', 'ruff_format' },
  dart = { 'dart_format' },
  sh = { 'shfmt', 'shellcheck' },
  bash = { 'shfmt', 'shellcheck' },
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
  markdown = {
    'injected', -- FIXME: semantic token
    -- 'pangu',
    -- 'autocorrect',
    'trim_whitespace',
  },
  help = { 'injected' },
  query = { 'format-queries' },
}

return {
  'stevearc/conform.nvim',
  cmd = 'ConformInfo',
  init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
  opts = {
    default_format_opts = { lsp_format = 'fallback' },
    formatters_by_ft = {
      -- handle project-local config
      ['*'] = function(buf)
        local opts = u.project.conform_ft_opts or {}
        local ft = vim.bo[buf].ft
        local fmters = #ft > 0 and (opts[ft] or ft_opts[ft]) or {}
        return u.merge(fmters, opts['*'] or ft_opts['*'] or {})
      end,
    },
    formatters = {
      latexindent = { inherit = true, prepend_args = { '--GCString' } }, -- need perl-unicode-linebreak
      bufpaste = { format = function(_, _, _, cb) cb(nil, vim.split(fn.getreg('+'), '\n')) end },
      nlua = {
        format = function(_, _, lines, cb)
          lines = vim
            .iter(lines)
            :map(function(line)
              line = line
                :gsub('vim%.api%.', 'api.') -- align
                :gsub('vim%.fn%.', 'fn.')
                :gsub('vim%.uv%.', 'uv.')
                :gsub('vim%.tbl_extend%(.force.,', 'u.merge(')
              return line
            end)
            :totable()
          cb(nil, lines)
        end,
      },
      uncrustify_nvim = {
        command = 'uncrustify',
        args = function(_, ctx)
          local root = fs.root(ctx.buf, '.git')
          local conf = fs.joinpath(root, '/src/uncrustify.cfg')
          return { '-q', '-l', 'C', '-c', conf }
        end,
      },
    },
  },
}
