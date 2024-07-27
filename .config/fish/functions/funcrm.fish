function funcrm --wraps=functions
    functions -e $argv
    funcsave $argv
end
