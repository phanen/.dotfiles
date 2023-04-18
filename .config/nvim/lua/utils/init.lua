local fmt = string.fmt
local M = {}

function M.get_nvim_version()
    local version = vim.version()
    return string.format("%d.%d.%d", version.major, version.minor, version.patch)
end

function M.get_full2half_vimcmd()
  return [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：　]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"', '　':'  '}[submatch(0)]/g<cr>
        ]]
end

-- context ...
M.next_colorscheme = (function()
  local id = 1
  local tab = { 'nordfox', 'tokyonight', 'catppuccin', 'rose-pine', 'doom-one', }
  return  function()
    id = (id + 1) % (#tab)
    vim.cmd('colorscheme ' .. tab[id + 1])
  end
end)()

M.dev_dir = vim.env.DEV_DIR or vim.fn.expand('~/demo')

return M
