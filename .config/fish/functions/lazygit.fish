function lazygit --wrap lazygit
    # HACK: no idea now, poor cli of lazygit
    git rev-parse --show-toplevel 1>/dev/null
    and command lazygit
end
