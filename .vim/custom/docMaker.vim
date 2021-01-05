" this is the general version of the docmake
" should work for scala, java, and c++

function! Harvest(macro)
    exec "normal! " . a:macro
    return @m
endfunction

function! MakeDoc(doReturn, argList)
    if b:did_ftplugin
        normal O/**
    else
        normal O/** **
    endif

    for i in a:argList
        exec 'normal! a @param ' . i . ''
    endfor

    if a:doReturn
        normal! a @return
    endif

    normal! a/

endfunction

function! DocMain(getReturnType, getName, getNumArgs, argDeli, argStart, getArgName, getArgNameLast, noReturn)
    let l:returnType = Harvest(a:getReturnType)
    let l:functionName = Harvest(a:getName)

    let l:argList = Harvest(a:getNumArgs)
    let l:names = []

    if argList !=# '()'
        let l:num = len(split(argList, a:argDeli))

        call Harvest(a:argStart)
        for i in range(num - 1)
            let l:temp = Harvest(a:getArgName)
            echom temp

            call add(names, temp)
        endfor

        let l:temp = Harvest(a:getArgNameLast)
        call add(names, temp)

    endif

    call MakeDoc(a:noReturn !=# returnType, names)

endfunction
