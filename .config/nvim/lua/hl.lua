local hi = function(name, val)
  -- Force links
  val.force = true
  -- Make sure that `cterm` attribute is not populated from `gui`
  val.cterm = val.cterm or {}
  -- Define global highlight
  vim.api.nvim_set_hl(0, name, val)
end

local function update_hl()
  -- https://github.com/neovim/neovim/pull/30192
  vim.cmd [[
    " this not work with url in other place (e.g. lua string/terminal buf)
    hi! @lsp.type.comment.lua guifg=none " fix "#xx"
    hi! @string.special.url.comment  term=underline cterm=underline ctermfg=44 gui=underline guifg=#00dfdf
    hi! @string.special.url.html     term=underline cterm=underline ctermfg=44 gui=underline guifg=#00dfdf
  ]]

  hi('WinBarNC', { link = 'WinBar' })
  -- https://www.reddit.com/r/neovim/comments/1f0smse/line_numbers_colored_relative_line_numbers/
  hi('LineNr', { fg = '#6c7086' })
  hi('CursorLineNr', { fg = 'orange', bg = '#313244' })
  -- hi LineNrAbove fg=#565f89
  -- hi LineNrBelow fg=#565f89
  hi('Status_LineNr', { fg = '#6c7086' })
  hi('Status_DivLine', { bg = '#1e1e2e', fg = '#313244' })
end

local color_path = vim.fs.joinpath(g.cache_path, 'fzf-lua/pack/fzf-lua/opt')
g.color_path = color_path
for dir, type in vim.fs.dir(color_path) do
  if type == 'directory' then vim.opt.rtp:append(vim.fs.joinpath(color_path, dir)) end
end

local colors_file = vim.fs.joinpath(g.state_path, 'colors.json')
local saved = u.fs.read_json(colors_file)
saved.colors_name = saved.colors_name or 'default'

if saved.colors_name and saved.colors_name ~= g.colors_name then
  vim.cmd.colorscheme { args = { saved.colors_name }, mods = { emsg_silent = true } }
  -- to fix fzf preview not dim, just never dim...
  update_hl()
end

if saved.bg then vim.go.bg = saved.bg end

u.aug['u/colorscheme'] = {
  'ColorScheme',
  function()
    if g.script_set_bg or g.script_set_colors then return end
    vim.schedule(function()
      local data = u.fs.read_json(colors_file)
      local colors_name = g.colors_name
      local bg = vim.go.bg
      if data.colors_name ~= colors_name or data.bg ~= bg then
        data.colors_name = g.colors_name
        data.bg = vim.go.bg
        u.fs.write_json(colors_file, data)
      end
      pcall(vim.system, { 'setbg', vim.go.bg })
      pcall(vim.system, { 'setcolor', g.colors_name })
      update_hl()
    end)
  end,
}
