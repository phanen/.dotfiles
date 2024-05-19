-- formatter
nx('gw', [[<cmd>lua r('conform').format { lsp_fallback = true }<cr>]])
local s = function(lhs, pattern)
  n(lhs, ('<cmd>%%%s<cr>``'):format(pattern))
  x(lhs, (':%s<cr>``'):format(pattern))
end
s(' rp', [[FullwidthPunctConvert]])
-- x(' rp', ':FullwidthPunctConvert<cr>') -- TODO: not change cursor pos
n(' rj', ':Pangu<cr>') -- TODO: not change cursor pos
x(' ro', ':!sort<cr>')
s(' rs', [[s/\s*$//g<cr>``]])
s(' rl', [[g/^$/d]])
s(' r*', [[s/^\([  ]*\)- \(.*\)/\1* \2/g]])
s(' r ', [[s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]])
