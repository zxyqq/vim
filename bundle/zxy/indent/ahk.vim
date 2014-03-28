" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetAhkIndent()

" function! GetAhkIndent() {{{
function! GetAhkIndent()
  let currlcon = getline(".")

  " if v:lnum == 1 || currlcon =~ "^\s*;"
  if v:lnum == 1
    return 0
  endif

  if currlcon =~ '::\s*$'
    return 0
  endif

  if currlcon =~ '^\s*#if'
    return 0
  endif

  if currlcon =~ '^\s*}'
    normal 0
    let sib = searchpair('{\s*$', '', '^\s*}','bnW') 
    return indent(sib)
  endif

  let prevlnum = prevnonblank(v:lnum-1)
  let prevlcon = getline(prevlnum)
  let prevlind = indent(prevlnum)

  if prevlcon =~ '{\s*$' || prevlcon =~ '::\s*$' 
    return &sw + prevlind
  endif
  return prevlind
endf
" }}}
