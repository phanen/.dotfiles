local n = map.n
local x = map.x

-- formatter
n('gw', [[<cmd>lua require('conform').format { lsp_fallback = true }<cr>]])
x('gw', [[:lua require('conform').format { lsp_fallback = true }<cr>]])

local s = function(lhs, pattern)
  map.n(lhs, ('<cmd>%%%s<cr>``'):format(pattern))
  map.x(lhs, (':%s<cr>``'):format(pattern))
end

s(' rp', [[FullwidthPunctConvert]])
-- x(' rp', ':FullwidthPunctConvert<cr>') -- TODO: not change cursor pos
n(' rj', ':Pangu<cr>') -- TODO: not change cursor pos
x(' ro', ':!sort<cr>')
s(' rs', [[s/\s*$//g<cr>``]])
s(' rl', [[g/^$/d]])
s(' r*', [[s/^\([  ]*\)- \(.*\)/\1* \2/g]])
s(' r ', [[s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]])
