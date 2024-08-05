return setmetatable({
  box = vim.g.no_nf and require('lib.static._box_no_nf') or require('lib.static._box'),
  borders = vim.g.no_nf and require('lib.static._borders_no_nf') or require('lib.static._borders'),
}, {
  __index = function(self, key)
    self[key] = require('lib.static.' .. key)
    return self[key]
  end,
})
