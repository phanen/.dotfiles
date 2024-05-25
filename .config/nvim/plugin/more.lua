g.netrw_banner = 0
g.netrw_cursor = 5
g.netrw_keepdir = 0
g.netrw_keepj = ''
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle = 1
g.netrw_localcopydircmd = 'cp -r'

g.fzf_layout = { window = { width = 0.7, height = 0.7, pos = 'center' } }
env.FZF_DEFAULT_OPTS = (env.FZF_DEFAULT_OPTS or '') .. ' --border=none --margin=0 --padding=0'
vim.cmd.nnoremap [[<leader><c-e> <cmd>FZF<cr>]]
