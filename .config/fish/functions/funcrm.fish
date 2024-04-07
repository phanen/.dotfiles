function funcrm --wraps=funced
    functions -e $argv
    funcsave $argv
end
