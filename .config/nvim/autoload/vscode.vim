if !exists('g:vscode')
  finish
endif

" LSP keymap settings
function! s:vscodeGoToDefinition(str)
    if exists('b:vscode_controlled') && b:vscode_controlled
        call VSCodeNotify('editor.action.' . a:str)
    else
        " Allow to function in help files
        exe "normal! \<C-]>"
    endif
endfunction

" Window and buffer keymap settings
function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

function! s:splitNew(...)
    let file = a:2
    call s:split(a:1, empty(file) ? '__vscode_new__' : file)
endfunction

function! s:closeOtherEditors()
    call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
    call VSCodeNotify('workbench.action.closeOtherEditors')
endfunction

function! s:manageEditorHeight(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewHeight' : 'workbench.action.decreaseViewHeight')
    endfor
endfunction

function! s:manageEditorWidth(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewWidth' : 'workbench.action.decreaseViewWidth')
    endfor
endfunction

function! vscode#setup() abort
    " Use VSCode syntax highlighting
    syntax off

    nnoremap K     <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
    nnoremap gD    <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
    nnoremap gd    <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
    nnoremap <C-]> <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
    nnoremap gO    <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
    nnoremap g.    <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

    xnoremap K     <Cmd>call VSCodeNotify('editor.action.showHover')<CR>
    xnoremap gD    <Cmd>call <SID>vscodeGoToDefinition('revealDeclaration')<CR>
    xnoremap gd    <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
    xnoremap <C-]> <Cmd>call <SID>vscodeGoToDefinition('revealDefinition')<CR>
    xnoremap gO    <Cmd>call VSCodeNotify('workbench.action.gotoSymbol')<CR>
    xnoremap g.    <Cmd>call VSCodeNotify('editor.action.referenceSearch.trigger')<CR>

    " Git keymap settings
    nnoremap ]c <Cmd>call VSCodeNotify('workbench.action.editor.nextChange')<CR>
    nnoremap [c <Cmd>call VSCodeNotify('workbench.action.editor.previousChange')<CR>

    " Navigation
    nnoremap <Leader>ff <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>
    nnoremap <Leader>.  <Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>

    command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
    command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
    command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
    command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
    command! -bang Only if <q-bang> ==# '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

    AlterCommand sp[lit] Split
    AlterCommand vs[plit] Vsplit
    AlterCommand new New
    AlterCommand vne[w] Vnew
    AlterCommand on[ly] Only

    " buffer management
    nnoremap <C-s>n <Cmd>call <SID>splitNew('h', '__vscode_new__')<CR>
    nnoremap <C-s>c <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

    xnoremap <C-s>n <Cmd>call <SID>splitNew('h', '__vscode_new__')<CR>
    xnoremap <C-s>c <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>

    " window/splits management
    nnoremap <C-s>s <Cmd>call <SID>split('h')<CR>
    nnoremap <C-s>v <Cmd>call <SID>split('v')<CR>
    nnoremap <C-s>= <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
    nnoremap <C-s>_ <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
    nnoremap <C-s>+ <Cmd>call <SID>manageEditorHeight(v:count, 'increase')<CR>
    nnoremap <C-s>- <Cmd>call <SID>manageEditorHeight(v:count, 'decrease')<CR>
    nnoremap <C-s>> <Cmd>call <SID>manageEditorWidth(v:count, 'increase')<CR>
    nnoremap <C-s>< <Cmd>call <SID>manageEditorWidth(v:count, 'decrease')<CR>
    nnoremap <C-s>o <Cmd>call VSCodeNotify('workbench.action.joinAllGroups')<CR>

    xnoremap <C-s>s <Cmd>call <SID>split('h')<CR>
    xnoremap <C-s>v <Cmd>call <SID>split('v')<CR>
    xnoremap <C-s>= <Cmd>call VSCodeNotify('workbench.action.evenEditorWidths')<CR>
    xnoremap <C-s>_ <Cmd>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
    xnoremap <C-s>+ <Cmd>call <SID>manageEditorHeight(v:count, 'increase')<CR>
    xnoremap <C-s>- <Cmd>call <SID>manageEditorHeight(v:count, 'decrease')<CR>
    xnoremap <C-s>> <Cmd>call <SID>manageEditorWidth(v:count, 'increase')<CR>
    xnoremap <C-s>< <Cmd>call <SID>manageEditorWidth(v:count, 'decrease')<CR>
    xnoremap <C-s>o <Cmd>call VSCodeNotify('workbench.action.joinAllGroups')<CR>

    " window navigation
    nnoremap <C-s>h <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    nnoremap <C-s>j <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
    nnoremap <C-s>k <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
    nnoremap <C-s>l <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
    nnoremap <C-s>H <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
    nnoremap <C-s>J <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
    nnoremap <C-s>K <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
    nnoremap <C-s>L <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
    nnoremap <C-s>w <Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
    nnoremap <C-s>W <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
    nnoremap <C-s>p <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>

    xnoremap <C-s>h <Cmd>call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
    xnoremap <C-s>j <Cmd>call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
    xnoremap <C-s>k <Cmd>call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
    xnoremap <C-s>l <Cmd>call VSCodeNotify('workbench.action.focusRightGroup')<CR>
    xnoremap <C-s>H <Cmd>call VSCodeNotify('workbench.action.moveEditorToLeftGroup')<CR>
    xnoremap <C-s>J <Cmd>call VSCodeNotify('workbench.action.moveEditorToBelowGroup')<CR>
    xnoremap <C-s>K <Cmd>call VSCodeNotify('workbench.action.moveEditorToAboveGroup')<CR>
    xnoremap <C-s>L <Cmd>call VSCodeNotify('workbench.action.moveEditorToRightGroup')<CR>
    xnoremap <C-s>w <Cmd>call VSCodeNotify('workbench.action.focusNextGroup')<CR>
    xnoremap <C-s>W <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
    xnoremap <C-s>p <Cmd>call VSCodeNotify('workbench.action.focusPreviousGroup')<CR>
endfunction
