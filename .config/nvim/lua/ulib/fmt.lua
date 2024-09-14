local Fmt = {}

Fmt.conform = function(opts)
  opts = u.merge({ lsp_format = 'fallback' }, opts or {})
  require('conform').format(opts)
end

return Fmt
