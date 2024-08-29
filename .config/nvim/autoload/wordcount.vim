" 'jspringyc/vim-word'

function! wordcount#WordCountLine()
    let s:iLine = line('.')
    let s:sLine = getline('.')

    " 判断当前行是否为空
    let s:lenLine = strchars(s:sLine)
    if s:lenLine == 0
        echom "Current line is empty."
        return
    endif
    " 中文字符
    let s:lenChinese = 0
    " 数字
    let s:lenDigit = 0
    " 英文字符
    let s:lenLetter = 0

    for c in split(s:sLine, '\zs')
        let s:iCharNr = char2nr(c)

        if s:iCharNr >= 48 && s:iCharNr <= 57
            let s:lenDigit += 1
        elseif (s:iCharNr >= 97 && s:iCharNr <= 122) || (s:iCharNr >= 65 && s:iCharNr <= 90)
            let s:lenLetter += 1
        elseif char2nr(c) >= 0x2000
            let s:lenChinese += 1
        endif
    endfor

    echom 'Line ' . s:iLine . ' Chars: ' . s:lenLine . ', Digit: ' . s:lenDigit . ', Letter: ' . s:lenLetter . ', Chinese: ' . s:lenChinese
endfunction

function! wordcount#WordCount()
    let s:sLines = getline(1, '$')

    let s:lenTotal = 0
    let s:lenChinese = 0
    let s:lenDigit = 0
    let s:lenLetter = 0
    let s:lenLines = len(s:sLines)

    for s:sLine in s:sLines
        " 记算总字符数
        let s:lenLine = strchars(s:sLine)
        let s:lenTotal += s:lenLine

        for c in split(s:sLine, '\zs')
            let s:iCharNr = char2nr(c)

            if s:iCharNr >= 48 && s:iCharNr <= 57
                let s:lenDigit += 1
            elseif (s:iCharNr >= 97 && s:iCharNr <= 122) || (s:iCharNr >= 65 && s:iCharNr <= 90)
                let s:lenLetter += 1
            elseif char2nr(c) >= 0x2000
                let s:lenChinese += 1
            endif
        endfor
    endfor

    echom 'Total: ' . s:lenTotal . ', Digit: ' . s:lenDigit . ', Letter: ' . s:lenLetter . ', Chinese: ' . s:lenChinese
endfunction
