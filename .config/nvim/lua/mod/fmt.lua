local n = map.n
local x = map.x

-- formatter
n('gw', [[<cmd>lua require('conform').format { lsp_fallback = true }<cr>]])
x('gw', [[:lua require('conform').format { lsp_fallback = true }<cr>]])

-- TODO: maybe need a project manager
-- neovim project local formatter
autocmd('FileType', {
  pattern = 'c',
  callback = function()
    local file_root = u.smart.root()
    -- error-prone, but work and short...
    local nvim_root = vim.fs.joinpath(env.HOME, 'b/neovim')
    if file_root ~= nvim_root then return end

    -- arch upstream ood now, perfer bundled
    local uncrustify_path = vim.fs.joinpath(nvim_root, 'build/usr/bin/uncrustify')
    if not fn.executable(uncrustify_path) then
      if fn.executable('uncrustify') then return end
      uncrustify_path = 'uncrustify'
    end

    -- unset lsp preset to make `formatprg` work
    vim.bo.formatexpr = ''
    local uncrustify_cfg_path = nvim_root .. '/src/uncrustify.cfg'
    vim.bo.formatprg = uncrustify_path .. ' -q -l C -c ' .. uncrustify_cfg_path
  end,
})

local s = function(lhs, pattern)
  map.n(lhs, ('<cmd>%%%s<cr>``'):format(pattern))
  map.x(lhs, (':%s<cr>``'):format(pattern))
end

s(' rp', [[FullwidthPunctConvert]])
-- x(' rp', ':FullwidthPunctConvert<cr>') -- TODO: not change cursor pos
n(' rj', ':Pangu<cr>') -- TODO: not change cursor pos
x(' ro', ':!sort<cr>')
s(' rs', [[s/\s*$//g<cr>``]])
s(' rl', [[g/^$/d]])
s(' r*', [[s/^\([  ]*\)- \(.*\)/\1* \2/g]])
s(' r ', [[s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g]])
