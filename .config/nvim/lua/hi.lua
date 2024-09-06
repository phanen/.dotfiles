-- vim.treesitter.language.register('bash', 'lua')
-- https://github.com/search?q=%40lsp.type.comment.lua&type=code
-- FIXME: toggle comment in vim.cmd
vim.cmd [[
" don't override luadoc
hi! @lsp.type.comment.lua        guifg=NONE
hi! @lsp.type.keyword.lua        guifg=NONE
hi! @lsp.type.macro.lua          guifg=NONE
hi! @lsp.mod.documentation.lua   guifg=NONE

hi! @string.special.url.comment  term=underline cterm=underline ctermfg=44 gui=underline guifg=#00dfdf
hi! @string.special.url.html     term=underline cterm=underline ctermfg=44 gui=underline guifg=#00dfdf
" TODO: url in other place (e.g. lua string/terminal buf)
" https://github.com/neovim/neovim/pull/30192

hi! link WinBarNC                WinBar
]]

local hi = function(name, val)
  -- Force links
  val.force = true
  -- Make sure that `cterm` attribute is not populated from `gui`
  val.cterm = val.cterm or {}
  -- Define global highlight
  vim.api.nvim_set_hl(0, name, val)
end

--hi('WinBarNC', { fg = 'WinBar' })
