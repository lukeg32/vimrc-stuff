function! LoadCpp()
    " load the files
    source ~/.vim/custom/vimrc_scala.vim

endfunction


autocmd VimEnter,BufNewFile *.scala :call LoadCpp()
