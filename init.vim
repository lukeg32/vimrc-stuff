"set packpath+=~/.config/nvim/packs/
"packadd nvim-treesitter

"call plug#begin('~/.config/nvim/plugged')

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

"call plug#end()

"lua <<EOF
"require'nvim-treesitter.configs'.setup {
"  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
"  highlight = {
"    enable = true,              -- false will disable the whole extension
"    disable = { "c", "rust" },  -- list of language that will be disabled
"  },
"}
"EOF

set relativenumber
set number
set tabstop=4

set shellcmdflag=-ic

set hls
" set tw=79
" set colorcolumn=80
" hi ColorColumn ctermbg=grey guibg=grey
" set fo+=t
"set fo-=l

set wildmenu
set wildmode=full

set shiftwidth=4 expandtab smartindent

"setlocal spell!
"set spell!
syntax on

set foldmethod=indent

set listchars=nbsp:~,tab:->,trail:-
set list

set mouse=a
set ignorecase smartcase

set showcmd

filetype plugin on
set background=light

set splitbelow
set splitright

nnoremap <leader>w 
nnoremap nh :noh<CR>

nnoremap H gT
nnoremap L gt

let g:sessions_dir = "~/.config/nvim/sessions"
exec 'nnoremap <leader>S :mks! ' . v:this_session . '<CR>'
exec 'nnoremap <leader>s :mks! ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'

exec 'nnoremap <leader>ss :so ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
