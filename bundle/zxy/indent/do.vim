if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetDoIndent()

"currently we only want the zero indent for the readme text file
func! GetDoIndent()
  return 0
endf
