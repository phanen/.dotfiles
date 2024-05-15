-- not well
-- textobj
local ox = function(...) map({ 'o', 'x' }, ...) end
ox('ih', ':<c-u>Gitsigns select_hunk<cr>')
local tobj = function(c, func)
  ox('i' .. c, ([[<cmd>lua require("various-textobjs").%s("inner", "inner")<cr>]]):format(func))
  ox('a' .. c, ([[<cmd>lua require("various-textobjs").%s("outer", "outer")<cr>]]):format(func))
end
tobj('c', 'multiCommentedLines')
tobj('g', 'entireBuffer')
tobj('i', 'indentation')
tobj('l', 'lineCharacterwise')
-- tobj('n', 'anyBracket')
tobj('q', 'anyQuote')
tobj('u', 'url')
ox('in', 'iB')
ox('an', 'aB')
