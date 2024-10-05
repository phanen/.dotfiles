return {
  'mtrajano/tssorter.nvim',
  cmd = 'TSSort',
  version = '*', -- latest stable version, use `main` to keep up with the latest changes
  opts = {
    sortables = {
      lua = {
        list = {
          node = 'field',
        },
        assign = {
          node = 'assignment_statement', -- treesitter node to capture

          -- ordinal = 'inline', -- OPTIONAL: nested node to do the sorting by. If this is not specified it will just sort based on
          -- node's text contents.

          -- OPTIONAL: function that takes in two nodes and returns true when first node should come first
          -- these are just tsnodes so you have all that functionality available to you
          -- if ordinals are specified in the config above they will be included at the end
          order_by = function(node1, node2, ordinal1, ordinal2)
            if ordinal1 and ordinal2 then return ordinal1 < ordinal2 end
            local line1 = require('tssorter.tshelper').get_text(node1)
            local line2 = require('tssorter.tshelper').get_text(node2)
            print(line1, line2)
            return line1 < line2
          end,
        },
      },
    },
  },
}
