if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

nnoremap <buffer>  ,mc !!boxes -d c-cmt2<CR>==
vnoremap <buffer>  ,mc mz!boxes -d c-cmt2<CR>='z
nnoremap <buffer>  ,xc !!boxes -d c-cmt2 -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d c-cmt2 -r<CR>='z
