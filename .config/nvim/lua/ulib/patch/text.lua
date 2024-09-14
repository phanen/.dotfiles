-- Text processing functions.

local M = {}

local ffi = require('ffi')

local he = ffi.new('char[512]')
for i = 0, 255 do
  local high_nibble, low_nibble = math.floor(i / 16), i % 16
  he[i * 2] =
    string.byte(high_nibble < 10 and tostring(high_nibble) or string.char(55 + high_nibble))
  he[i * 2 + 1] =
    string.byte(low_nibble < 10 and tostring(low_nibble) or string.char(55 + low_nibble))
end

local hd = ffi.new('char[256]')
for i = 0, 9 do
  hd[string.byte('0') + i] = i
end
for i = 0, 5 do
  hd[string.byte('A') + i] = 10 + i
  hd[string.byte('a') + i] = 10 + i
end

--- Hex encode a string.
---
--- @param str string String to encode
--- @return string : Hex encoded string
function M.hexencode(str)
  local len = #str
  local enc = ffi.new('char[?]', len * 2 + 1)

  for i = 0, len - 1 do
    local byte = str:byte(i + 1)
    enc[i * 2] = he[byte * 2]
    enc[i * 2 + 1] = he[byte * 2 + 1]
  end

  return ffi.string(enc, len * 2)
end

--- Hex decode a string.
---
--- @param enc string String to decode
--- @return string? : Decoded string
--- @return string? : Error message, if any
function M.hexdecode(enc)
  if #enc % 2 ~= 0 then return nil, 'string must have an even number of hex characters' end

  local len = math.floor(#enc / 2)
  local str = ffi.new('char[?]', len + 1)

  for i = 0, len - 1 do
    local high_nibble = hd[enc:byte(i * 2 + 1)]
    local low_nibble = hd[enc:byte(i * 2 + 2)]
    if high_nibble == nil or low_nibble == nil then return nil, 'invalid character in input' end
    str[i] = ffi.cast('char', bit.bor(bit.lshift(high_nibble, 4), low_nibble))
  end

  return ffi.string(str, len)
end

return M
