let g:made = '/**'
let g:make =  ['i/**o']
let g:make += ['i Program#: TODOo']
let g:make += ['i 2020-MM-DDo']
let g:make += ['i @author lgantar19@georgefox.eduo']
let g:make += ['i*/']
let g:make += ['ipublic class "mp']
let g:make += ['o{']
let g:make += ['o}O-x$']

let g:success = 'true'


function! Length()
    let l =  len(split(@m, ','))
    if split(@m, ",") == ["()"]
        let l = -1
    endif
    return l
endfunction

function! GetParam(Params)
    let m = @m              " temp var
    let @m = ''             " sets to empty
    normal 2wve"myw
    if (@m == '[]')         " if list arg, then move over one more
        normal ve"my
    endif
    call add(a:Params, @m)  " ^ goes to 1st param copies to @m <then to Params
    let @m = m              " restore @m
    return a:Params         " return params
endfunction

function! MakeComments(return)
    let Params = []                " make list, init i

    let i = 0
    let c = Length()               " lenght gives the amount of params we have

    if c != -1                     " length returns -1 when no params
        while i < c
            let Params = GetParam(Params) " extracts each param
            let i += 1
        endwhile
    endif

    if b:did_ftplugin
        normal O/**
    else
        normal O/** **
    endif
                                   " ^ makes the doc header
    let m = @m                     " temp var to not lose @m

    for i in Params
        let @m = i                 " set @m to what we want to paste in
        if b:did_ftplugin
            normal a @param "mpa
        else
            normal a @param "mpa*
        endif
    endfor " ^ pastes each param in, proper formatting

    let @m = m                     " restore @m

    if a:return                    " adds a return part if we asked for one
        if b:did_ftplugin
            normal a @return
        else
            normal a @return*
        endif
    endif
                                   " v closes out the doc string
    normal a/
endfunction

function! ConstructorComment()
    let m = @m                     " temp var so @m isn't lost
                           " v saves everything inside the () inclusive, to @m
    normal 03wv%"my

    call MakeComments(0)              " calls MakeComments with returns being false

    let @m = m                     " @m won't have changed

endfunction

function! MethodComment(return, static)
    let m = @m                     " temp var so @m isn't lost

    if a:static                    " go on word futher b/c of static
        normal 05wv%"my
    else                           "^ V saves params inside (), to @m
        normal 04wv%"my
    endif

    call MakeComments(a:return) " MakeComments will make docstring, giving return

    let @m = m               " set to temp to tie loose ends

endfunction

function! Find(String, Target)
    let len = len(a:String)
    let i = 0
    let success = 0
    while i < len
        if a:String[i] == a:Target
            let success = 1
        endif
        let i += 1
    endwhile

    return success
endfunction

" gets the lines above and below and returns them
function! GetAboveBelow()
    let u = @u
    let i = @i
    normal k0v$"uy
    normal 2j0v$"iyk
    let l:above = split(@u)
    if len(l:above) != 1
        let l:above = @u
    else
        let l:above = l:above[0]
    endif

    let l:below = split(@i)
    if len(l:below) != 1
        let l:below = @i
    else
        let l:below = l:below[0]
    endif
    let @u = u
    let @i = i
    let l:list = [l:above, l:below]
    return l:list
endfunction

function! GetType()
    let coords = getcurpos()
    let m = @m                 " gets the identifiers of this line
    normal "myy
    let continue = Find(@m, "(")

    let line = coords[1]
    let col = coords[2]

    let list = GetAboveBelow()
    let above = list[0]
    let below = list[1]
                               " V gets between start of line and (
    if continue
        normal 0/(v0w"my

        let @m = @m[:-2]                     " removes the ( from @m
        nohl
        " 1 is truth, 0 is false
        let return = 1                    " false if void/filename found in ID
        let method = 1                    " only false if filename found
        let constructor = 0               " true if filename found
        let invalid = 0                   " forces to quit
        let extras = 0                    " accouts for static/abstract
        let publicprivate = 1             " must find this to not be invalid
        let filename = expand("%:r")      " filename
        let identifiers = split(@m)       " the identifiers in a list
    else
        let publicprivate = 0
        let identifiers = []
    endif
                                 "V if less than 1 then can't be valid
                                 "V checks if the method has already been made
    if len(identifiers) <= 1 || above == "*/" || below == "{" || ! continue
        let invalid = 1
    endif

    for i in identifiers
        if filename == i       " if file name found then has to be constructor
            let constructor = 1
            let method = 0
            let return = 0
        endif

        if "new" == i                 " no comment for new objects
            let invalid = 1
        endif

        if "static" == i || "abstract" == i "account for abstract/static method
            let extras = 1
        endif

        if "public" == i || "private" == i || "protected" == i
            let publicprivate = 0     " find public/private/protected ids

        endif

        if "class" == i               " class docstring handled in creation
            let invalid = 1
        endif

        if "void" == i                " void = no return doc string
            let return = 0
        endif
    endfor

    if publicprivate                  " no public/private no generator
        let invalid = 1
    endif

                           "VV will do the functions for constructor or method
                           "VV and puts cursor in a resonable place
    if invalid != 1
        if constructor
            call ConstructorComment()
        endif

        if method
            call MethodComment(return, extras)
        endif
                               " makes the tabs stay and cursor proper pos

        "normal jo{}O-$ for old braces
        normal jA {}O-$
        normal x$

        if return              " if return then cursor must be the line before
            normal Areturn null;
            normal O-$x$
        endif
    else                       " resets cursor if not generating
       call cursor(line, col)
    endif
endfunction


" <leader> = \
""""""""" start of importer script
" the dictionary that had keys=a use of a class, value=the import location with ;
let s:ImportDic =  {'ArrayList<': 'java.util.ArrayList;'}
let s:ImportDic['Scanner('] = 'java.util.Scanner;'
let s:ImportDic['File('] = 'java.io.File;'
let s:ImportDic['FileNotFoundException'] = 'java.io.FileNotFoundException;'
let s:ImportDic['InputMismatchException'] = 'java.util.InputMismatchException;'
let s:ImportDic['NoSuchElementException'] = 'java.util.NoSuchElementException;'
let s:ImportDic['Arrays.'] = 'java.util.Arrays;'
let s:ImportDic['PrintWriter('] = 'java.io.PrintWriter;'
"echo s:ImportDic
" a helper method that returns a list of keys from a dictionary
function! GetKeys(ImportDic)
    let all = items(a:ImportDic)
    let l:new = []

    for i in all
        call add(l:new, i[0])
    endfor

    return new
endfunction

" finds the values of the keys, returns a list of keys that had their value found
function! GetImports(all)
    let success = 0
    let made = []
    let both = items(a:all)

    for i in both
        let success = search(i[1])
        if success != 0                     " if found value, then add key to list
            call add(made, i[0])
        endif
    endfor

    return made
endfunction

" finds the keys in the file, returns a list of the keys that were found
function! ToImport(keys)
    let success = 0
    let toMake = []

    for i in a:keys
        let success = search(i)
        if success != 0
            call add(toMake, i)
        endif
    endfor

    return toMake
endfunction

" prints the imports to the file, next ot existing ones, or after header
function! MakeImports(keys, new)
    if a:new == "False"                     " this means we must make the imports our self
        normal! gg4jo
    else                                    " find those imports and add some friends
        normal! gg
        let line = search("import")
        exec "normal! " . line . "G"
    endif

    for i in a:keys
        exec "normal! Oimport " . s:ImportDic[i]
    endfor                                  " this prints all imports using the keys given

endfunction

" this will return a list with the unique values of make relative to made
function! RmDups(make, made)
    let noDups = []                         " this list will have the unique elements

    for i in a:make
        let pass = 0

        for j in a:made
            if i == j
                let pass = 1                " found dup, won't get added
            endif
        endfor

        if pass == 0
            call add(noDups, i)             " adds to list elements that didn't have a friend in the other list
        endif
    endfor

    return noDups
endfunction

" the main function
function! Imports()
    let coords = getcurpos()
    let line = coords[1]                    " saves the coords so you don't notice a thing
    let col = coords[2]

    let keys = GetKeys(s:ImportDic)
    let toMake = []                         " gets keys out of the dictionary
    let made = []

    let toMake = ToImport(keys)
    let made = GetImports(s:ImportDic)      " finds things to import, and what has been imported

    let noDups = []
    let doAnything = "True"
    if (len(toMake) <= 0)                   " checks to make sure the lists have stuff in them
        let doAnything = "False"
    endif

    if (len(made) <= 0)
        let doAnything = "False"
        let noDups = toMake
    endif

    if doAnything == "True"
        let noDups = RmDups(toMake, made)   " if the lists have stuff, then proccess out the dups
    endif

    if len(noDups) > 0
        let newLine = "False"
        if len(made) > 0
            let newLine = "True"            " this will make imports be placed next to existing ones
        endif

        call MakeImports(noDups, newLine)   " if dups has stuff, then make imports
    endif

    call cursor(line, col)
endfunction

" creates a command that you can call, may do fancy stuff later
command! Import :call Imports()
"""""" end of importer script

"""""""start of refactorer   
" make all braces like the first one
command! BraceCheck :call CheckConsistantBrace()

" toggle the first one, then change the others to match
command! ToggleBrace :call ToggleBraces()

" toggle the variable, if true then actually fix no outpu, else just output
" some stuff
command! ToggleBraceCheckFix :let b:fixBraces = !b:fixBraces
let b:fixBraces = 1

function! ToggleBraces()
    let l:coords = getcurpos()
    let l:line = coords[1]                    " saves the coords so you don't notice a thing
    let l:col = coords[2]

    let l:old = b:fixBraces
    let b:fixBraces = 1
    let l:type = GetTypeBrace()


    " switch the first braces, then check consistant will move the others
    normal gg
    call search('public class')
    if l:type
        normal J

    else
        normal $i

    endif

    call CheckConsistantBrace()

    let b:fixBraces = l:old
    call cursor(l:line, l:col)
endfunction

function! RmExtraWhiteSpaces()
    execute '%s/ \+$//g'
    execute '%s/\t/    /g'
    "execute '/}\n\n    \/\*\*'
endfunction

function! CheckConsistantBrace()
    " start at the top
    normal gg
    let l:coords = getcurpos()
    let l:line = coords[1]                    " saves the coords so you don't notice a thing
    let l:col = coords[2]
    let l:m = @m              " temp var
    let l:type = GetTypeBrace()

    echo "You are now at " . l:type . " 0=BEST, 1=ALMOND"

    " get brace lines
    let l:braces = GetBraceLines()

    " loop to each and check if almond or best
    let l:failure = CheckBrace(l:braces, l:type)

    " if you want autofix
    if b:fixBraces
        call FixBraces(l:failure, l:type)
    endif


    let @m = l:m              " restore @m
    call cursor(l:line, l:col)
endfunction

function! GetBraceLines()
    let l:braces = []
    let l:finding = 1

    while l:finding
        let l:success = search("{", "W")

        if l:success
            if PokeAround()
                let l:coords = getcurpos()
                let l:line = l:coords[1]                    " saves the coords for later
                let l:col = l:coords[2]

                " add to the good list
                call add(l:braces, [l:line, l:col])
            else
                "just keep looking
            endif

            " moves down so we don't get stuck on the last one
            normal j
        else
            let l:finding = 0

        endif

    endwhile

    let l:str = ""
    for i in l:braces
        let l:str = l:str . " [" . i[0] . ", " . i[1] . "],"
    endfor

    return l:braces
endfunction

function! CheckBrace(braces, type)
    let l:failed = []
    let l:cur = 0

    for l:coord in a:braces
        call cursor(l:coord[0], l:coord[1])
        normal V"my
        " i couldn't get the and to work, so erererer
        let l:raw = substitute(@m, " ", "", "g")
        let l:rawer = substitute(l:raw, "{", "", "g")
        let l:rawerer = substitute(l:rawer, "\n", "", "g")

        if l:rawerer ==# ""
            let l:cur = 1
        else
            let l:cur = 0
        endif

        if l:cur !=# a:type
            if !b:fixBraces
                echom "You have a problem [" . l:coord[0] . ", " . l:coord[1] . "]"
            endif

            call add(l:failed, l:coord)
        endif
    endfor

    return l:failed
endfunction


function! FixBraces(braces, type)
    let l:offset = 0
    let l:running = 1

    for l:coord in a:braces
        call cursor(l:coord[0] + offset, l:coord[1])

        if a:type " best to almond
            let l:offset = l:offset + 1
            " get the tab length, pastes before the {
            normal muF)%^hv0"my`uild0"mP
        else " almond to best
            let l:offset = l:offset - 1
            normal kJ
        endif
    endfor
endfunction


function! PokeAround()
    let l:good = 0

    normal $v"my

    " copies the last char, if { then its probably good
    if @m ==# "{"
        let l:good = 1
    endif

    return l:good
endfunction


function! GetTypeBrace()
    let l:type = 1
    let l:filename = expand("%:r")
    let l:success = search("public class " . filename)

    " get brace or not
    normal $v"my

    " best if its found, otherwise almond
    if @m == "{"
        let l:type = 0
    endif

    " check for consistency
    "call CheckConsistantBrace(l:type)
    return l:type
endfunction

"function! Find()

"endfunction

" when ) is pressed runs generator
inoremap ) )<C-\><C-O>:call GetType()<CR>
" when \ is pressed runs processor
"inoremap <leader>make <C-\><C-O>:call Process()<CR>
"inoremap { {<CR>}<Esc>ko
inoremap { {<CR>}<Esc>koaa
inoremap <leader>out System.out.println(<ESC>

"nnoremap <leader>r :so ~/.vimrc<CR> | :so ~/.vim/custom/vimrc_java.vim<CR>

