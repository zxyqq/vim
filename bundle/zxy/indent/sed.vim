if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=SedIndentGet(v:lnum)
setlocal indentkeys=o,O,*<Return>,<>>,<bs>,{,}

fun! SedIndentGet(lnum)
  return 0
endf
