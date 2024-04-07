function e
    # https://www.reddit.com/r/bash/comments/13rqfjd/detecting_chinese_characters_using_grep
    # https://github.com/soimort/translate-shell/issues/298
    # https://github.com/fish-shell/fish-shell/issues/3847
    # | tr -d "\n"
    if echo "$argv" | grep -q -P '\p{Script=Han}'
        trans zh:en -- "$argv"
    else
        trans en:zh -- "$argv"
    end
end
