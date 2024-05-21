-- https://github.com/xiyaowong/fast-cursor-move.nvim

local limit = 150
local threshold_tbls = setmetatable({}, {
  __index = function(t, k)
    if vim.tbl_contains({ 'h', 'l', 'w', 'b', 'e', 'W', 'B', 'E' }, k) then
      t[k] = { 7, 14, 20, 26, 31, 36, 40, 45, 49, 52, 51 }
    elseif vim.tbl_contains({ 'j', 'k', '<c-d>', '<c-u>' }, k) then
      t[k] = { 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60 }
    end
    return t[k]
  end,
})

local get_step = (function()
  local prev_direction
  local prev_time = 0
  local move_count = 0
  return function(direction)
    if direction ~= prev_direction then
      prev_time = 0
      move_count = 0
      prev_direction = direction
    else
      local time = vim.uv.hrtime()
      local elapsed = (time - prev_time) / 1e6
      if elapsed > limit then
        move_count = 0
      else
        move_count = move_count + 1
      end
      prev_time = time
    end

    local threshold = threshold_tbls[direction]
    -- calc step
    for idx, count in ipairs(threshold) do
      if move_count < count then
        if direction == '<c-d>' or direction == '<c-u>' then
          idx = vim.fn.round(idx * vim.o.lines)
        end
        return idx
      end
    end
    local count = #threshold
    if direction == '<c-d>' or direction == '<c-u>' then
      count = vim.fn.round(count * vim.o.lines)
    end
    return count
  end
end)()

---@param direction "h" | "j" | "k" | "l"
---@return "h" | "gj" | "gk" | "l"
local function get_move(direction)
  if direction == 'j' then
    return 'gj'
  elseif direction == 'k' then
    return 'gk'
  else
    ---@diagnostic disable-next-line: return-type-mismatch
    return direction
  end
end

local move = function(direction)
  return function()
    local move_chars = get_move(direction)
    if vim.fn.reg_recording() ~= '' or vim.fn.reg_executing() ~= '' then return move_chars end
    local step = get_step(direction)
    if vim.v.count > 0 then
      -- return move_chars
      return direction
    end

    return step .. move_chars
  end
end

for _, motion in ipairs({ 'h', 'j', 'k', 'l', 'w', 'b', 'e', 'W', 'B', 'E', '<c-d>', '<c-u>' }) do
  nx(motion, move(motion), { expr = true })
end
