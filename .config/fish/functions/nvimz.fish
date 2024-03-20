function nvimz --wrap nvim
  set -lx NVIM_APPNAME (fd 'init.lua' ~/.config/ -I --prune -F -x basename {//} | fzf -1 --preview 'bat -f ~/.config/{}/init.lua' -0)
  nvim $argv
end
