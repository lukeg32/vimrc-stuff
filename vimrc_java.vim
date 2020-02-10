let g:made = '/**'
let g:make =  ['i/**']
let g:make += ['i * Program#: TODO']
let g:make += ['i * 2020-MM-DD']
let g:make += ['i * @author lgantar19@georgefox.edu']
let g:make += ['i */']
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

function! GetParams(return)
    let Params = []                " make list, init i

    let i = 0
    let c = Length()               " lenght gives the amount of params we have

    if c != -1                     " length returns -1 when no params
        while i < c
            let Params = GetParam(Params) " extracts each param
            let i += 1
        endwhile
    endif

    normal O/** **
                                   " ^ makes the doc header
    let m = @m                     " temp var to not lose @m

    for i in Params
        let @m = i                 " set @m to what we want to paste in
        normal a @param "mpa*
    endfor " ^ pastes each param in, proper formatting

    let @m = m                     " restore @m

    if a:return                    " adds a return part if we asked for one
        normal a @return*
    endif
                                   " v closes out the doc string
    normal a/
endfunction

function! ConstructorComment()
    let m = @m                     " temp var so @m isn't lost
                           " v saves everything inside the () inclusive, to @m
    normal 03wv%"my

    call GetParams(0)              " calls GetParams with returns being false

    let @m = m                     " @m won't have changed

endfunction

function! MethodComment(return, static)
    let m = @m                     " temp var so @m isn't lost

    if a:static                    " go on word futher b/c of static
        normal 05wv%"my
    else                           "^ V saves params inside (), to @m
        normal 04wv%"my
    endif

    call GetParams(a:return) " GetParams will make docstring, giving return

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
    let m = @m                 " gets the identifiers of this line
    normal "myy
    let continue = Find(@m, "(")

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
        let static = 0                    " will acount for static when reading
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

        if "static" == i              " make generator account for static
            let static = 1
        endif

        if "public" == i || "private" == i
            let publicprivate = 0     " find public/private in identifiers

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
            call MethodComment(return, static)
        endif
                               " makes the tabs stay and cursor proper pos
        normal jo{}O-$
        normal x$

        if return              " if return then cursor must be the line before
            normal Areturn null;
            normal O-$x$
        endif
    else                       " resets cursor if not generating
        normal /)$
    endif
endfunction
" <leader> = \

" when ) is pressed runs generator
inoremap ) )<C-\><C-O>:call GetType()<CR>
inoremap { {<CR>}<Esc>ko
