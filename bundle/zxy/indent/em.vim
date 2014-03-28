" Only load this indent file when no other was loaded.
if exists("b:did_em_indent")
  finish
endif

let b:did_em_indent=1

setlocal indentexpr=GetEmIndent()

func! GetEmIndent()
  let currline = getline(".")

  " 注释行
  if currline =~ '^\/\*' ||
	\ currline =~ '^macro'
    return 0
  endif

  let prevlnum = prevnonblank(v:lnum-1)

  " block开始行
  if currline =~ '^\s*{'
    return indent(prevlnum)
  endif

  if currline =~ '^[ \t]*}'
    normal 0
  endif

  if(getline(prevlnum) =~ '^[ \t]*if')
    return &sw + indent(prevlnum)
  endif

  let sib = searchpair('^[ \t]*{', '', '^[ \t]*}','bnW') 

  if (sib > 0)
    if currline =~ '^[ \t]*}'
      return indent(sib)
    else
      return &sw + indent(sib)
    endif
  else
    return indent(v:lnum)
  endif
endf
