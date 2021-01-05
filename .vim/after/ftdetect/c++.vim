
function! LoadCpp()
    " load the files
    source ~/.vim/custom/vimrc_c++.vim

endfunction


autocmd VimEnter,BufNewFile *.cpp :call LoadCpp()
