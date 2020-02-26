set relativenumber
set tabstop=4

set shellcmdflag=-ic

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

" VIDEO:
" Provides tab-completion for all file related tasks also fuzzy
set path+=**

" create the tags file, uses ctags
command! MakeTags !ctags -R .

" ^] to jump to tag under cursor
" g^] for ambiguous tags
" ^t to jump back up the tag stack
"
" autocomplete
" good stuff in |ins-complete|
" ^x^n for JUST this file
" ^x^f for filenames
" ^x^] for tags only
" ^n for anything specified b the complete option
" |netrw-browse-maps|

set showcmd

nnoremap <leader>html :-1read ~/.vim/skeletion/java.skel<CR>3jwf>a
" folds
set foldmethod=manual
hi Folded ctermbg=black ctermfg=blue
set sessionoptions+=folds

" augroup AutoSaveFolds
"     autocmd!
"     autocmd BufWinLeave * mkview
"     autocmd BufWinEnter * silent loadview
" augroup END

" no highlighting on file start/reload vimrc
noh
let @/=''
" nnoremap nh :let @/=''<CR>
nnoremap nh :noh<CR>
" set background=dark
set background=light

" status line
set laststatus=2
set statusline=
"set statusline+=%#Visual#
"set statusline+=%{StatuslineGit()}
"set statusline+=%#LineNr#\ 
set statusline+=%#ModeMsg#
set statusline+=\ %F
set statusline+=\ %#LineNr#
set statusline+=%m
set statusline+=%=
" set statusline+=%#Search#
" set statusline+=%{@/}

" set statusline+=%#PmenuSel#
" set statusline+=%0.10{@0}

set statusline+=%#PmenuSel#
set statusline+=\ [%{v:register}]

set statusline+=\ %#TabLineFill#
if expand('%:e') != '' || expand('%:t') == '.vimrc'
    set statusline+=\ %y
endif

" set statusline+=%y
" set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
" set statusline+=\[%{&fileformat}\]
" set statusline+=\ %p%%
set statusline+=%#StatusLine#
set statusline+=\ %p%%\ %l:%c
set statusline+=\ 

if exists("b:did_ftplugin")
    filetype plugin on
else
    let b:did_ftplugin = 0
endif

""

set nocompatible

set ruler

" this is makes the side bar show up
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
" augroup ProjectDrawer
"     autocmd!
"     autocmd VimEnter * :Vexplore
" augroup END


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
    let type = expand("%:e")
    if (g:made != getline('1'))
        exe "-1read ~/.vim/skeletion/".type.".skel"
        exe ":%s/NAME/".filename
        exe "normal! 2jA"
    endif
"     let m = @m
"     let @m = filename
"     if (g:made != getline('1'))
"         for i in g:make
"             exe "normal! " . i
"         endfor
"     endif
    " let @m = m
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

"opens on right and below for split
set splitbelow
set splitright

" change slip with \w
nnoremap <leader>w 

nnoremap <leader>W gt
nnoremap <leader>i :call Indent()<CR>
nnoremap <leader>r :so ~/.vimrc<CR>
exec 'nnoremap <leader>s :mks! ' . v:this_session . '<CR>'

" command! -nargs=1 jcon call s:MyFunc(<f-args>)

syntax on
