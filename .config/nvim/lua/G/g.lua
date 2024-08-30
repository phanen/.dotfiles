-- not sure if we should g.xx -> u.xx
g.config_path = fn.stdpath('config') ---@as string
g.state_path = fn.stdpath('state') ---@as string
g.cache_path = fn.stdpath('cache') ---@as string
g.data_path = fn.stdpath('data') ---@as string
g.run_path = fn.stdpath('run') ---@as string

-- env.NVIM_NO3RD

env.COLORTERM = 256

-- g.border = 'rounded'
g.border = { '┏', '━', '┓', '┃', '┛', '━', '┗', '┃' }
-- g.border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }

g.has_ui = #api.nvim_list_uis() > 0
g.has_gui = fn.has('gui_running') == 1
g.modern_ui = g.has_ui and env.DISPLAY ~= nil

-- FIXME(?): env is ''? nil?
g.no_nf = not g.modern_ui or false
g.no_3rd = not g.modern_ui or false

-- g.lazy_shada = true

g.disable_intro = true

-- disable autocmd
g.disable_AutoCwd = true
-- g.disable_AutoHlCursorLine = true
-- g.disable_CmdwinEnter = true

-- seems resolved(?): https://github.com/ibhagwan/fzf-lua/discussions/1296
g.disable_cache_docs = false

g.disable_Autosave = true

g.vendor_bar = true

-- netrw
g.netrw_banner = 0
g.netrw_cursor = 5
g.netrw_keepdir = 0
g.netrw_keepj = ''
g.netrw_list_hide = [[\(^\|\s\s\)\zs\.\S\+]]
g.netrw_liststyle = 1
g.netrw_localcopydircmd = 'cp -r'

-- fzf packaged from vimfiles
g.fzf_layout = { window = { width = 0.7, height = 0.7, pos = 'center' } }
env.FZF_DEFAULT_OPTS = (env.FZF_DEFAULT_OPTS or '') .. ' --border=none --margin=0 --padding=0'

g.mapleader = ' '
g.maplocalleader = '+'

-- disable some builtin ftplugin features
g.markdown_recommended_style = 0
g.no_man_maps = 0

-- project consts
g.nvim_root = env.HOME .. '/b/neovim' -- todo: check exist
