set relativenumber
set tabstop=4

set hls
set tw=79
set colorcolumn=79
hi ColorColumn ctermbg=grey guibg=grey
set fo+=t
set fo-=l

set wildmenu
set wildmode=full

set shiftwidth=4 expandtab autoindent smartindent

set listchars=nbsp:~,tab:->,trail:-
set list

set nocompatible

set ruler

" this is makes the side bar show up
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup ProjectDrawer
    autocmd!
    autocmd VimEnter * :Vexplore
augroup END


function! Indent()
    normal 0>>j0
endfunction

""""""""
" how many times we have loaded a file to vimrc
let g:load = 0

" loads files based off of the extention
function! FileLoader()
    let g:load = 1
    let filetype = expand("%:e")
    if filetype == "java"
        source ~/.vim/custom/vimrc_java.vim
    endif
endfunction

" loads files, then checks to see if this file has been made already
function! CheckFile()
    call FileLoader()
    let filename = expand("%:r")
    let m = @m
    let @m = filename
    if (g:made != getline('1'))
        for i in g:make
            exe "normal! ". i
        endfor
    endif
    let @m = m
endfunction

" this runs on new file, will run the check file
autocmd BufNewFile *.java  :call CheckFile()

" makes sure files have a chance to load at least once
if ! g:load
    call FileLoader()
endif
"""""""""

" <leader> = \

" when ) is pressed runs generator
"inoremap ) )<C-\><C-O>:call GetType()<CR>
" inoremap { {<CR>}<Esc>ko
"1202
"let 

nnoremap <leader>i :call Indent()<CR>
nnoremap <leader>r :so ~/.vimrc<CR>
exec 'nnoremap <leader>s :mks! ' . v:this_session . '<CR>'

" command! -nargs=1 jcon call s:MyFunc(<f-args>)

syntax on
