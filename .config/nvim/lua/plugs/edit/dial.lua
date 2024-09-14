return {
  'monaqa/dial.nvim',
  keys = {
    { '<c-a>', '<plug>(dial-increment)', mode = { 'n', 'x' } },
    { '<c-x>', '<plug>(dial-decrement)', mode = { 'n', 'x' } },
    { 'g<c-a>', 'g<plug>(dial-increment)', remap = true, mode = { 'n', 'x' } },
    { 'g<c-x>', 'g<plug>(dial-decrement)', remap = true, mode = { 'n', 'x' } },
    { ' <c-a>', '"=p<cr><plug>(dial-increment)', mode = { 'n', 'x' } },
    { ' <c-x>', '"=p<cr><plug>(dial-decrement)', mode = { 'n', 'x' } },
    { '+<c-a>', '"=digit<cr><plug>(dial-increment)', mode = { 'n', 'x' } },
    { '+<c-x>', '"=digit<cr><plug>(dial-decrement)', mode = { 'n', 'x' } },
  },
  config = function()
    local augend = require 'dial.augend'
    local find_pattern = require('dial.augend.common').find_pattern

    local and_or_sym = augend.constant.new {
      elements = { '&&', '||' },
      word = false,
      cyclic = true,
    }
    local and_or = augend.constant.new {
      elements = { 'and', 'or' },
      word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
      cyclic = true, -- "or" is incremented into "and".
    }

    local oct = augend.user.new {
      find = find_pattern('0%[0-7]+'),
      add = function(text, addend, _)
        if addend > 0 then
          text = ('0x%x'):format(tonumber(text, 8))
        else
          text = tostring(tonumber(text, 8))
        end
        return { text = text, cursor = #text }
      end,
    }
    local hex = augend.user.new {
      find = find_pattern('0x%x+'),
      add = function(text, addend, _)
        if addend > 0 then
          text = tostring(tonumber(text))
        else
          text = ('0%o'):format(text)
        end
        return { text = text, cursor = #text }
      end,
    }
    local dec = augend.user.new {
      find = find_pattern('%d+'),
      add = function(text, addend, _)
        if addend > 0 then
          text = ('0x%x'):format(tonumber(text))
        else
          text = ('0%o'):format(text)
        end
        return { text = text, cursor = #text }
      end,
    }

    local square = augend.user.new {
      find = find_pattern('%d+'),
      add = function(text, addend, cursor)
        local n = tonumber(text)
        n = math.floor(n * (2 ^ addend))
        text = tostring(n)
        cursor = #text
        return { text = text, cursor = cursor }
      end,
    }

    require('dial.config').augends:register_group {
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.integer.alias.octal,
        augend.integer.alias.binary,
        augend.constant.alias.bool,
        and_or_sym,
        and_or,
      },
      digit = { oct, hex, dec },
      p = { square },
    }
  end,
}
