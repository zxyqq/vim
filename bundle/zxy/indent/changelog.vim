" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetChangelogIndent()

func! GetChangelogIndent()
  let currlcon = getline(".")

  if currlcon =~ '[ \t]*v\d.\d'
    return 0
  endif

  if currlcon =~ '[ \t]*[Date\]:'
    return &sw
  endif

  let prevlnum = prevnonblank(v:lnum-1)
  return indent(prevlnum) 
endf
