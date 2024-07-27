if g.vscode then return end

-- Colorschemes other than the default colorscheme looks bad when the terminal
-- does not support truecolor

-- if true then return end

if not g.modern_ui then
  if g.has_ui then vim.cmd.colorscheme('default') end
  return
end

-- -- manage color by fzf-lua
local color_path = vim.fs.joinpath(g.cache_path, 'fzf-lua/pack/fzf-lua/opt')
g.color_path = color_path
for dir, type in vim.fs.dir(color_path) do
  if type == 'directory' then vim.opt.rtp:append(vim.fs.joinpath(color_path, dir)) end
end

local colors_file = vim.fs.joinpath(g.state_path, 'colors.json')

-- 1. Restore dark/light background and colorscheme from json so that nvim
--    "remembers" the background and colorscheme when it is restarted.
-- 2. Spawn setbg/setcolors on colorscheme change to make other nvim instances
--    and system color consistent with the current nvim instance.

local saved = u.json.read(colors_file)
saved.colors_name = saved.colors_name or 'default'

if saved.bg then vim.go.bg = saved.bg end

if saved.colors_name and saved.colors_name ~= g.colors_name then
  vim.cmd.colorscheme({
    args = { saved.colors_name },
    mods = { emsg_silent = true },
  })
end

-- TODO: completion
au('Colorscheme', {
  group = ag('Colorscheme', {}),
  desc = 'Spawn setbg/setcolors on colorscheme change.',
  callback = function()
    if g.script_set_bg or g.script_set_colors then return end

    vim.schedule(function()
      local data = u.json.read(colors_file)
      if data.colors_name ~= g.colors_name or data.bg ~= vim.go.bg then
        data.colors_name = g.colors_name
        data.bg = vim.go.bg
        if not u.json.write(colors_file, data) then return end
      end

      pcall(vim.system, { 'setbg', vim.go.bg })
      pcall(vim.system, { 'setcolor', g.colors_name })
    end)
  end,
})
