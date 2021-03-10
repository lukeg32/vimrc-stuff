
" line length thing
set formatoptions+=t
set tw=79
set colorcolumn=80
hi ColorColumn ctermbg=grey guibg=grey

" make sure we properly trigger the docMaker
function! Trigger()
    " save our pos
    let l:coords = getcurpos()
    let l:line = coords[1]
    let l:col = coords[2]

    source ~/.vim/custom/docMaker.vim

    " docMaker assumes we start at the beggining of the line for each item
    " and that the current line has the whole definition
    let l:getReturnType = '$F(b2hv^"my^'

    let l:getName = '$F(hvb"my'

    let l:getNumArgs = '$F(v%"my^'
    let l:argDeli = ","
    let l:argStart = '$F('
    let l:getArgName = 'f,bve"myf,'
    let l:getArgNameLast = 'f)bve"my'

    let l:noReturn = "void"

    call DocMain(getReturnType, getName, getNumArgs, argDeli, argStart, getArgName, getArgNameLast, noReturn)


    call cursor(line, col)
endfunction


inoremap <leader>s std::
inoremap { {<CR>}<Esc>ko

command! Tr :call Trigger()
