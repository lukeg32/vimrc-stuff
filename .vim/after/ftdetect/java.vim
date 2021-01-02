" loads my java plugins
let g:jvimentered = 0

function! LoadJava(did)
    " get java stuff
    source ~/.vim/custom/vimrc_java.vim

    " inizialise the global vars
    if !exists("g:jpc")
        let g:jpc = []
        let g:jpcFree = []
    endif

    if !exists("g:jpm")
        let g:jpm = []
        let g:jpmFree = []
    endif

    if !exists("b:jprm")
        let b:jprm = []
    endif

    if !exists("b:jprc")
        let b:jprc = []
    endif

    " this var will make us wait for the buffer to have a VimEnter event
    if g:jvimentered == 0
        let g:jvimentered = a:did

    endif


    if g:jvimentered
        " load skeleton if new
        if (!filereadable(expand("%")) && !exists("b:skel"))
            "echom "do skel"
            let filename = expand("%:r")
            exe "-1read ~/.vim/skeleton/java.skel"
            exe ":%s/NAME/".filename
            exe "normal! 2jA"

            " add our class to the global var
            call AddToConstruct(filename, 1)

            " to stop from double skel, and no need to parse
            let b:skel = 1
            let b:parsed = 1

        elseif !exists("b:parsed")
            " this var means we only wide scale parse once
            "echom expand("%:r") . " parse"

            " highlighting in our file
            call FindClasses()
            call FindMethods()
            let b:parsed = 1

        endif


        " will clear the publicMethod/constructor, and apply whats in the
        " global vars
        "echom expand("%:r") . " run"
        call GetOtherTerms()

    end

endfunction

"autocmd VimEnter,BufReadPost,BufNewFile *.java :call LoadJava()

" when every we move buffers, ie tab to tab, it will update the highlighting
autocmd BufEnter *.java :call LoadJava(0)

" when ever we enter a file, or a new file
autocmd VimEnter,BufNewFile *.java :call LoadJava(1)
