function lazygit --wrap lazygit
    # HACK: no idea now, poor cli of lazygit
    git rev-parse --is-inside-work-tree 1>/dev/null
    or return

    #set -q KITTY_INSTALLATION_DIR 
    #and command kitten @launch --cwd (pwd) --type=overlay lazygit
    #or command lazygit

    command lazygit
end
