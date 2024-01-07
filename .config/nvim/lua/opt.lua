local o = vim.o

o.clipboard = "unnamedplus"
o.mouse = "a"
o.undofile = true
o.number = true
o.relativenumber = true

o.termguicolors = true
o.fileencodings = "ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1"
o.whichwrap = "b,s,h,l"

o.ignorecase = true -- use /C
o.smartcase = true

o.tabstop = 4
o.softtabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.autoindent = true
o.breakindent = true
o.shiftround = true

o.jumpoptions = "stack"
o.scrolloff = 16
o.completeopt = "menuone,noselect,noinsert"
o.splitright = true
o.showbreak = "↪ "

o.list = true
o.listchars = o.listchars .. ",leadmultispace:│ "

o.updatetime = 1000 -- for CursorHold
o.timeoutlen = 100
-- o.ttimeout = false -- avoid sticky escape as alt
o.ttimeoutlen = 0

o.synmaxcol = 200

-- wezterm integration
local base64 = function(data)
  data = tostring(data)
  local bit = require "bit"
  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local b64, len = "", #data
  local rshift, lshift, bor = bit.rshift, bit.lshift, bit.bor

  for i = 1, len, 3 do
    local a, b, c = data:byte(i, i + 2)
    b = b or 0
    c = c or 0

    local buffer = bor(lshift(a, 16), lshift(b, 8), c)
    for j = 0, 3 do
      local index = rshift(buffer, (3 - j) * 6) % 64
      b64 = b64 .. b64chars:sub(index + 1, index + 1)
    end
  end

  local padding = (3 - len % 3) % 3
  b64 = b64:sub(1, -1 - padding) .. ("="):rep(padding)

  return b64
end

local set_user_var = function(key, value) io.write(string.format("\027]1337;SetUserVar=%s=%s\a", key, base64(value))) end
set_user_var()

-- Signs
---@param opts {highlight: string, icon: string}
local function sign(opts)
  vim.fn.sign_define(opts.highlight, {
    text = opts.icon,
    texthl = opts.highlight,
    linehl = opts.highlight .. "Line",
  })
end

local error = "" -- '✗'
local warn = "" -- 
local info = "󰋼" --  ℹ 󰙎 
local hint = "󰌶" --  ⚑

sign { highlight = "DiagnosticSignError", icon = error }
sign { highlight = "DiagnosticSignWarn", icon = warn }
sign { highlight = "DiagnosticSignInfo", icon = info }
sign { highlight = "DiagnosticSignHint", icon = hint }

vim.cmd [[
" line object, https://vi.stackexchange.com/questions/24861/selector-for-line-of-text
function! Textobj_line(count) abort
    normal! gv
    if visualmode() !=# 'v'
    normal! v
    endif
    let startpos = getpos("'<")
    let endpos = getpos("'>")
    if startpos == endpos
    execute "normal! ^o".a:count."g_"
    return
    endif
    let curpos = getpos('.')
    if curpos == endpos
    normal! g_
    let curpos = getpos('.')
    if curpos == endpos
        execute "normal!" (a:count+1)."g_"
    elseif a:count > 1
        execute "normal!" a:count."g_"
    endif
    else
    normal! ^
    let curpos = getpos('.')
    if curpos == startpos
        execute "normal!" a:count."-"
    elseif a:count > 1
        execute "normal!" (a:count-1)."-"
    endif
    endif
endfunction
xnoremap <silent> il :<C-U>call Textobj_line(v:count1)<CR>
onoremap <silent> il :<C-U>execute "normal! ^v".v:count1."g_"<CR>
]]
-- vim:foldmethod=marker
