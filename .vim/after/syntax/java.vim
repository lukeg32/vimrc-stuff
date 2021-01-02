"Do Not Move This Line!!!
"syn match javaPublicMethod "\v(enqueue|enqueueAll|enqueueHead|head|tail|dequeue|dequeueTail|clear|depth|isEmpty|iterator|reverseIterator|getValue|getNext|getPrevious|setValue|setNext|setPrevious|hasNext|next|setUp|none|addStuff|addStuffHead|addStuffHeadRmBack|iter|iterBack|iteradd|clearOther|clear|forEach|removeTail|remove)\("me=e-1
"
"syn match javaPublicMethod "\<\l\a*("me=e-1
"syn match javaPublicMethod "\%(\(public|private\) \)"
" Paste methods below
"syn cluster javaTop add=javaPublicMethod,javaPrivateMethod
" this one does nothing right now

"hi def link javaPublicMethod        Function
"hi def link javaPrivateMethod       Function

" creates highlighing groups, with their styles

hi javaPublicMethod        cterm=italic ctermfg=darkcyan
hi javaPrivateMethod       cterm=italic ctermfg=darkred
hi javaPublicConstructor   cterm=bold ctermfg=lightmagenta
hi javaPrivateConstructor  cterm=italic ctermfg=red
