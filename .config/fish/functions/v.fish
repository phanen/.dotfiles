function v --wrap nvim
  if command -q ~/b/neovim/build/bin/nvim
    VIMRUNTIME=~/b/neovim/runtime ~/b/neovim/build/bin/nvim $argv
  else
    command nvim $argv
  end
end

