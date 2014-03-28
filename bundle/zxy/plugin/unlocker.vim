if exists("loaded_unlocker")
  finish
endif
let loaded_unlocker=1
let UnlockerPrg='C:\Program Files\Unlocker\Unlocker.exe'

command! -nargs=0 Unlock call Unlock(Foo_GetFileName())

func! Unlock(fn)
  let fn = substitute(a:fn, '\/', '\\', 'g')
  let cmd = '"' . g:UnlockerPrg. '"' . ' "'. fn .'"'
  silent! execute '!start ' . cmd 
endf

