
let g:getClipboardInfoPrg = expand("<sfile>:h")."/utils/getClipboardInfo.exe"
func! CopyorMoveFileFromClipboard()
  let result = system(g:getClipboardInfoPrg)
  let items = split(result, '?')
  let length = len(items)
  if(length <= 1)
    return
  endif
  let op = remove(items, 0)
  for fn in items
    call FileOpIt(op, fn)
  endfor
endf

func! FileOpIt(op, fn)
  let dest = expand("%:p:h")
  if(a:op == "copy")
    call CopyIt(a:fn, dest)
  elseif(a:op == "cut")
    call MoveIt(a:fn, dest)
  endif
endf

noremap <A-F8> :call CopyorMoveFileFromClipboard()<cr>
