local Script = {}

---@param should_patch boolean
Script.update_lazy_patch = function(should_patch)
  local lazy_config = require('lazy.core.config')
  local patch_dir = fs.joinpath(g.config_path, 'patches')
  u.fs.ls(patch_dir, function(path, name, _)
    local plug_path = fs.joinpath(lazy_config.options.root, (name:gsub('%.patch$', '')))
    if not uv.fs_stat(plug_path) then return end
    u.git { 'restore', '.', cwd = plug_path }:wait()
    if should_patch then
      local obj = u.git { 'apply', '--ignore-space-change', path, cwd = plug_path }:wait()
      if obj.code == 0 then
        u.log.hl_echo('Patched: ' .. name, 'DevIconVimrc') -- need devicon loaded
      else
        u.log.hl_echo('Failed:  ' .. name, 'Error')
      end
    end
  end)
end

Script.update_lazy_cache_docs = function()
  local lazy_config = require('lazy.core.config')
  -- note: seems not loaded when LazyInstall
  -- for _, plugin in pairs(lazy_config.plugins) do
  --   local docs = fs.joinpath(plugin.dir, 'doc')
  --   if uv.fs_stat(docs) then pcall(vim.cmd.helptags, docs) end
  -- end
  local docs_path = g.docs_path .. '/doc'
  fn.mkdir(docs_path, 'p')
  u.fs.ls(docs_path, function(path, _, ty)
    if ty == 'file' then uv.fs_unlink(path) end
  end)

  for _, plugin in pairs(lazy_config.plugins) do
    local docs = fs.joinpath(plugin.dir, 'doc')
    if uv.fs_stat(docs) then
      u.fs.ls(docs, function(path, name, ty)
        if ty ~= 'file' then return true end
        if name == 'tags' then
          uv.fs_unlink(path)
        elseif name:sub(-4) == '.txt' then
          uv.fs_copyfile(path, fs.joinpath(docs_path, name))
        end
      end)
    end
  end
  -- require('lazy.core.config').options.root
  -- local from, to = docs_path .. '/tags', g.lazy_path .. '/doc/tags'
  pcall(vim.cmd.helptags, docs_path)
  -- uv.fs_unlink(to)
  -- uv.fs_copyfile(from, to) -- 1. also need copy all txt path(...) 2. lazy.nvim override tags again if we copy to lazy.nvim
end

Script.update_meta = function(path)
  if g.updating_meta then return end
  g.updating_meta = true

  local global = g.config_path .. '/lua/rc.lua'
  local ulib = g.config_path .. '/lua/ulib'
  path = path or g.config_path .. '/lua/_meta.lua'

  local lines = { [[--- @meta]], [[--- AUTO GENERATED]] }

  -- provide sematics token: @lsp.typemod.variable.defaultLibrary.lua
  lines[#lines + 1] = ''
  lines[#lines + 1] = ([[--- parsed from %s]]):format((global:gsub('^' .. g.config_path, ''))) -- note: no escape
  local content = assert(u.fs.read_file(global))
  vim
    .iter(vim.split(content, '\n', { tirmempty = true }))
    :filter(function(line) return line:match('^_G%.') end)
    :each(function(line)
      local key, rhs = line:match('^_G%.(%w+) = (.+)$')
      if rhs:match('vim') then
        lines[#lines + 1] = ('_G.%s = vim.%s'):format(key, key)
      else
        lines[#lines + 1] = ('_G.%s = %s'):format(key, rhs)
      end
    end)

  -- provide lazy load libu meta info
  lines[#lines + 1] = ''
  lines[#lines + 1] = ([[--- parsed from %s]]):format(ulib:gsub('^' .. g.config_path, '')) -- note: no escape
  u.fs.ls(ulib, function(_, name, ty)
    if ty == 'file' and name:match('^[^_].*%.lua$') then
      local base = name:match('([^%.]+)%.lua$')
      local line = ([[u.%s = require('ulib.%s') ---@source ulib/%s.lua]]):format(base, base, base)
      lines[#lines + 1] = line
    end
  end)
  u.fs.write_file_by_lines(path, lines)
  local buf = fn.bufadd(path)
  fn.bufload(buf)
  u.fmt.conform { buf = buf }
  api.nvim_buf_call(buf, function() vim.cmd.write { bang = true } end)
  g.updating_meta = false
end

Script.update_spec = function(path)
  -- be careful of racing
  if g.updating_specs then return end
  g.updating_specs = true

  path = path or g.config_path .. '/lua/pm.lua'
  local root = g.config_path .. '/lua/plugs'
  local pat_gen = '--- AUTO GENERATED'

  local lines = {}
  local function walk_plugs(_root, _prefix)
    u.fs.ls(_root, function(fname, name, ty)
      if ty == 'directory' then walk_plugs(fname, ('%s.%s'):format(_prefix, name)) end
      if ty == 'file' and name:match('%.lua$') then
        local base = name:match('([^%.]+)%.lua$')
        lines[#lines + 1] = ([[  { import = '%s.%s' },]]):format(_prefix, base)
      end
    end)
  end

  lines[#lines + 1] = pat_gen
  lines[#lines + 1] = 'return {'
  walk_plugs(root, 'plugs')
  lines[#lines + 1] = '}'

  -- write to file
  local buf = fn.bufadd(path)
  fn.bufload(buf)
  local buf_lines = api.nvim_buf_get_lines(buf, 0, -1, false)
  local index = vim
    .iter(ipairs(buf_lines))
    :find(function(key, item) return vim.startswith(item, pat_gen) and key or nil end)
  index = index or api.nvim_buf_line_count(buf)
  api.nvim_buf_set_lines(buf, index - 1, -1, true, lines)
  u.fmt.conform { buf = buf }
  api.nvim_buf_call(buf, function() vim.cmd.write { bang = true } end)
  g.updating_specs = false
end

Script.update_chore = function(should_patch)
  Script.update_lazy_patch(should_patch)
  Script.update_lazy_cache_docs()
  Script.update_meta()
  Script.update_spec()
  fn.delete(lsp.get_log_path())
end

---@param clean boolean clean build
Script.update_nvim = function(clean)
  if not u.is.nvim_local_build() then return end
  local cmds = { 'fish -c "upd-nvim -p"' }
  if clean then cmds[#cmds + 1] = '&& make distclean' end
  cmds[#cmds + 1] = '&& fish -c "upd-nvim"'
  local cmd = table.concat(cmds, ' ')
  ---@diagnostic disable-next-line: missing-fields
  u.muxterm.spawn {
    cmd = cmd,
    cwd = g.nvim_root,
    on_exit = function()
      vim.cmd.helptags('$VIMRUNTIME/doc')
      vim.cmd [[up!|mks!/tmp/reload.vim]]
      local init_cmd = ([[lua u.muxterm.spawn{ cmd = "%s", cwd = "%s" }]]):format(
        'lazygit',
        g.nvim_root
      )
      u.fs.write_file('/tmp/reload.vim', init_cmd, 'a')
      vim.cmd [[cq!123]]
    end,
  }
end

return Script
