function _set_title
    printf "\e]2$(fish_title $argv)\a"
    $argv
end
