local M = {}

function M.get_nvim_version()
    local version = vim.version()
    return string.format("%d.%d.%d", version.major, version.minor, version.patch)
end

function M.get_full2half_vimcmd()
  return [[
        <cmd>%s/[，、（）［］｛｝＜＞？／；。！“”：]/\={'，':', ', '、':', ', '（':'(', '）':')', '［':'[', '］':']', '｛':'{', '｝':'}', '＜':'<', '＞':'>', '？':'? ', '／':'\/', '；':'; ', '。':'. ', '：': ': ', '！': '! ', '”': '"', '“': '"'}[submatch(0)]/g<cr>]]
end

-- context ...
M.next_colorscheme = (function()
  local id = 1
  local tb = { 'nordfox', 'tokyonight', 'catppuccin', 'rose-pine', }
  return  function()
    id = (id + 1) % (#tb) + 1
    vim.cmd('colorscheme' .. tb[id])
  end
end)()

return M
