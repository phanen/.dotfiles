local util = {}

local getregion = function(mode)
  local sl, sc = vim.fn.line 'v', vim.fn.col 'v'
  local el, ec = vim.fn.line '.', vim.fn.col '.'
  if sl > el then
    sl, sc, el, ec = el, ec, sl, sc
  elseif sl == el and sc > ec then
    sc, ec = ec, sc
  end
  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
  if mode == 'v' then
    if #lines == 1 then
      lines[1] = lines[1]:sub(sc, ec)
    else
      lines[1] = lines[1]:sub(sc)
      lines[#lines] = lines[#lines]:sub(1, ec)
    end
  elseif mode == '\022' then -- not sure behavior
    for i, line in pairs(lines) do
      if #line >= ec then
        lines[i] = line:sub(sc, ec)
      elseif #line < sc - 1 then
        lines[i] = (' '):rep(ec - sc + 1)
      elseif #line < sc then
        lines[i] = ''
      else
        lines[i] = line:sub(sc, nil)
      end
    end
  end
  return lines
end

-- get visual selected with no side effect
util.getregion = function(mode)
  mode = mode or vim.api.nvim_get_mode().mode
  if not vim.tbl_contains({ 'v', 'V', '\022' }, mode) then
    return {}
  end
  local ok, lines = pcall(vim.fn.getregion, vim.fn.getpos '.', vim.fn.getpos 'v', { type = mode })
  if ok then
    return lines
  end
  return getregion(mode)
end

util.q = function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- Close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      -- Close floating windows that can be focused
      if config.relative ~= '' and config.focusable then
        vim.api.nvim_win_close(win, false) -- do not force
        count = count + 1
      end
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('q', true, true, true), 'n', false)
  end
end

util.lazy_update_doc = function()
  local docs_path = vim.fs.joinpath(vim.g.docs_path, 'doc')
  local lazy_util = package.loaded['lazy.util']
  local lazy_config = package.loaded['lazy.core.config']
  vim.fn.mkdir(docs_path, 'p')
  lazy_util.ls(docs_path, function(path, _, _)
    if type == 'file' then
      vim.uv.fs_unlink(path)
    end
  end)
  for _, plugin in pairs(lazy_config.plugins) do
    vim.print(plugin.dir)
    local docs = vim.fs.joinpath(plugin.dir, 'doc')
    if lazy_util.file_exists(docs) then
      lazy_util.ls(docs, function(path, name, type)
        if type ~= 'file' then
          return
        end
        if name == 'tags' then
          vim.uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          vim.uv.fs_copyfile(path, vim.fs.joinpath(docs_path, name))
        end
      end)
    end
  end
  vim.cmd.helptags(docs_path)
end

return util
