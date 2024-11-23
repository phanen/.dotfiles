local Swap = {}

local hl = api.nvim_create_namespace('substitute.exchange')
api.nvim_set_hl(0, 'SubstituteExchange', { link = 'Search', default = true })

local function is_blockwise(vmode) return vmode:byte() == 22 or vmode == 'block' or vmode == 'b' end

local get_next_char_bytecol = function(linenr, colnr)
  local line = vim.fn.getline(linenr)
  local utf_index = vim.str_utfindex(line, 'utf-8', math.min(line:len(), colnr + 1))

  return vim.str_byteindex(line, 'utf-8', utf_index)
end

local get_marks = function(bufnr)
  local start_mark, finish_mark = '[', ']'
  -- if is_visual(vmode) then
  -- start_mark, finish_mark = '<', '>'
  -- end
  local pos_start = api.nvim_buf_get_mark(bufnr, start_mark)
  local pos_finish = api.nvim_buf_get_mark(bufnr, finish_mark)

  return {
    start = { row = pos_start[1], col = pos_start[2] },
    finish = { row = pos_finish[1], col = pos_finish[2] },
  }
end

local get_register_type = function(vmode)
  if vmode == 'block' then return 'b' end
  if vmode == 'line' then return 'l' end
  return 'c'
end

local substitute_text = function(bufnr, start, finish, regtype, replacement, replacement_regtype)
  regtype = get_register_type(regtype)
  replacement_regtype = get_register_type(replacement_regtype)

  if 'l' == regtype then
    vim.api.nvim_buf_set_lines(bufnr, start.row - 1, finish.row, false, replacement)

    local end_mark_col = string.len(replacement[#replacement]) + 1
    local end_mark_row = start.row + vim.tbl_count(replacement) - 1

    return {
      { start = { row = start.row, col = 0 }, finish = { row = end_mark_row, col = end_mark_col } },
    }
  end

  if is_blockwise(regtype) then
    if is_blockwise(replacement_regtype) then
      local marks = {}
      for row = start.row, finish.row, 1 do
        if start.col > finish.col then
          start.col, finish.col = finish.col, start.col
        end
        local current_row_len = vim.fn.getline(row):len()
        local last_replacement = table.remove(replacement, 1) or ''
        if current_row_len > 0 then
          vim.api.nvim_buf_set_text(
            bufnr,
            row - 1,
            start.col,
            row - 1,
            current_row_len > finish.col and get_next_char_bytecol(finish.row, finish.col)
              or current_row_len,
            { last_replacement }
          )

          table.insert(marks, {
            start = { row = row, col = start.col },
            finish = { row = row, col = start.col + string.len(last_replacement) },
          })
        end
      end

      return marks
    end

    local marks = {}
    for row = finish.row, start.row, -1 do
      local current_row_len = vim.fn.getline(row):len()
      if start.col > finish.col then
        start.col, finish.col = finish.col, start.col
      end

      if current_row_len > 0 then
        vim.api.nvim_buf_set_text(
          bufnr,
          row - 1,
          current_row_len > start.col and start.col or current_row_len,
          row - 1,
          current_row_len > finish.col and get_next_char_bytecol(finish.row, finish.col)
            or current_row_len,
          replacement
        )

        local end_mark_col = string.len(replacement[#replacement])
        if vim.tbl_count(replacement) == 1 then end_mark_col = end_mark_col + start.col end
        table.insert(marks, 1, {
          start = { row = row, col = start.col },
          finish = { row = row, col = end_mark_col },
        })
      end
    end

    return marks
  end

  if start.row > finish.row then
    vim.api.nvim_buf_set_text(
      bufnr,
      start.row - 1,
      start.col,
      start.row - 1,
      start.col,
      replacement
    )
  else
    local current_row_len = vim.fn.getline(finish.row):len()

    vim.api.nvim_buf_set_text(
      bufnr,
      start.row - 1,
      start.col,
      finish.row - 1,
      current_row_len > finish.col and get_next_char_bytecol(finish.row, finish.col)
        or current_row_len,
      replacement
    )
  end

  local end_mark_col = string.len(replacement[#replacement])
  if vim.tbl_count(replacement) == 1 then end_mark_col = end_mark_col + start.col end
  local end_mark_row = start.row + vim.tbl_count(replacement) - 1

  return { { start = start, finish = { row = end_mark_row, col = end_mark_col } } }
end

local text = function(bufnr, start, finish, vmode)
  if start.row > finish.row then return { '' } end

  local regtype = get_register_type(vmode)
  if 'l' == regtype then
    return vim.api.nvim_buf_get_lines(bufnr, start.row - 1, finish.row, false)
  end

  if 'b' == regtype then
    local text = {}
    for row = start.row, finish.row, 1 do
      local current_row_len = vim.fn.getline(row):len()

      local end_col = current_row_len > finish.col and get_next_char_bytecol(finish.row, finish.col)
        or current_row_len
      if start.col > end_col then end_col = start.col end

      local lines = vim.api.nvim_buf_get_text(bufnr, row - 1, start.col, row - 1, end_col, {})

      for _, line in pairs(lines) do
        table.insert(text, line)
      end
    end

    return text
  end

  return vim.api.nvim_buf_get_text(
    0,
    start.row - 1,
    start.col,
    finish.row - 1,
    get_next_char_bytecol(finish.row, finish.col),
    {}
  )
end

function get_register_type(vmode)
  if is_blockwise(vmode) or 'b' == vmode then return 'b' end

  if vmode == 'V' or vmode == 'line' or vmode == 'l' then return 'l' end

  return 'c'
end

-- Returns
--  < if origin comes before target
--  > if origin comes after target
--  [ if origin includes target
--  ] if origin is included in target
--  = if origin and target overlap
local compare_regions = function(origin, target)
  if origin.regtype == 'b' or target.regtype == 'b' then
    vim.notify("Exchange doesn't works with blockwise selections", vim.log.levels.INFO, {})
    return '='
  end

  if origin.regtype == 'l' then
    origin.marks.start.col = 0
    origin.marks.finish.col = vim.fn.getline(origin.marks.finish.row):len()
  end

  if target.regtype == 'l' then
    target.marks.start.col = 0
    target.marks.finish.col = vim.fn.getline(target.marks.finish.row):len()
  end

  local origin_offset = {
    start = vim.api.nvim_buf_get_offset(0, origin.marks.start.row - 1) + origin.marks.start.col,
    finish = vim.api.nvim_buf_get_offset(0, origin.marks.finish.row - 1) + origin.marks.finish.col,
  }

  local target_offset = {
    start = vim.api.nvim_buf_get_offset(0, target.marks.start.row - 1) + target.marks.start.col,
    finish = vim.api.nvim_buf_get_offset(0, target.marks.finish.row - 1) + target.marks.finish.col,
  }

  --  < if origin comes before target
  if origin_offset.finish < target_offset.start then return '<' end

  --  > if origin comes after target
  if origin_offset.start > target_offset.finish then return '>' end

  --  [ if origin includes target
  if
    origin_offset.start <= target_offset.start and origin_offset.finish >= target_offset.finish
  then
    return '['
  end

  --  ] if origin includes target
  if
    target_offset.start <= origin_offset.start and target_offset.finish >= origin_offset.finish
  then
    return ']'
  end

  return '='
end

local function do_exchange(vmode)
  local origin = vim.b.swap_save_node
  local regtype = get_register_type(vmode)
  local target = { marks = get_marks(0), regtype = regtype }
  local cmp = compare_regions(origin, target)
  if cmp == '=' then return end
  if cmp == '>' or cmp == ']' then
    origin, target = target, origin
  end

  local origin_text = text(0, origin.marks.start, origin.marks.finish, origin.regtype)
  local target_text = text(0, target.marks.start, target.marks.finish, target.regtype)

  if cmp == '<' or cmp == '>' then
    substitute_text(
      0,
      target.marks.start,
      target.marks.finish,
      target.regtype,
      origin_text,
      origin.regtype
    )
  end

  substitute_text(
    0,
    origin.marks.start,
    origin.marks.finish,
    origin.regtype,
    target_text,
    target.regtype
  )

  if vim.b.swap_save_curpos then
    api.nvim_win_set_cursor(0, vim.b.swap_save_curpos)
    vim.b.swap_save_curpos = nil
  end
end

local prepare_exchange = function(vmode)
  local marks = get_marks(0)
  local regtype = get_register_type(vmode)
  vim.hl.range(
    0,
    hl,
    'SubstituteExchange',
    { marks.start.row - 1, regtype ~= 'l' and marks.start.col or 0 },
    { marks.finish.row - 1, regtype ~= 'l' and marks.finish.col + 1 or 0 },
    { regtype = ({ char = 'v', line = 'V' })[vmode], inclusive = false }
  )

  vim.b.swap_save_node = { marks = marks, regtype = regtype }

  vim.b.swap_save_esc = fn.maparg('<esc>', 'n', false, true)
  map.n['<esc>'] = Swap.cancel

  api.nvim_buf_attach(0, false, {
    on_lines = function()
      Swap.cancel()
      return true
    end,
  })

  if vim.b.swap_save_curpos then
    api.nvim_win_set_cursor(0, vim.b.swap_save_curpos)
    vim.b.swap_save_curpos = nil
  end
end

Swap.operator = function()
  vim.o.opfunc = 'v:lua.u.swap.opfunc'
  if api.nvim_get_mode().mode:match('[Vv\022]') then vim.b.swap_motion = '`>' end
  vim.b.swap_save_curpos = api.nvim_win_get_cursor(0)
  api.nvim_feedkeys(('g@%s'):format(vim.b.swap_motion or ''), 'mi', false)
end

---@param vmode "char" | "line" | "block"
Swap.opfunc = function(vmode)
  if vmode == 'block' then error("[SWAP] doesn't works with blockwise selections") end

  if vim.b.swap_save_node then
    do_exchange(vmode)
    return
  end

  prepare_exchange(vmode)
end

Swap.cancel = function()
  api.nvim_buf_clear_namespace(0, hl, 0, -1)
  vim.b.swap_save_node = nil
  if not vim.b.swap_save_esc then return end
  if vim.tbl_isempty(vim.b.swap_save_esc) then
    map.n['<esc>'] = '<nop>'
  else
    fn.mapset('n', false, vim.b.swap_save_esc)
  end
  vim.b.swap_save_esc = nil
end

return Swap
