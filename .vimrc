set relativenumber
set number
set tabstop=4

set shellcmdflag=-ic

set hls
" set tw=79
" set colorcolumn=80
" hi ColorColumn ctermbg=grey guibg=grey
set fo+=t
set fo-=l

set wildmenu
set wildmode=full

set shiftwidth=4 expandtab autoindent smartindent
"setlocal spell!

set listchars=nbsp:~,tab:->,trail:-
set list

set mouse=a
set ignorecase smartcase

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

" so we get the default plugins
filetype plugin on

"autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> %s/\s\+$//e :retab

" <leader> = \ for reference

"opens on right and below for split
set splitbelow
set splitright

" change slip with \w
nnoremap <leader>w 

nnoremap H gT
nnoremap L gt

" ctrl-s for the win
nnoremap <C-S> :w<CR>
"nnoremap <C-S> :w<CR>
nnoremap <leader>r :windo e! <bar> :windo so ~/.vimrc<CR>
let g:sessions_dir = "~/.vim/sessions"
exec 'nnoremap <leader>S :mks! ' . v:this_session . '<CR>'
exec 'nnoremap <leader>s :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'

exec 'nnoremap <leader>ss :so ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'

" command! -nargs=1 jcon call s:MyFunc(<f-args>)

syntax on

" highlight debug
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
