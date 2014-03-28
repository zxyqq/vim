if exists("b:did_zxy_plugin")
  finish
endif

let b:did_zxy_plugin = 1

setlocal cindent shiftwidth=4
setlocal expandtab
setlocal softtabstop=8
setlocal formatoptions+=o
setlocal textwidth=80
setlocal fdm=indent
setlocal fdl=99

nnoremap <buffer>  ,mc !!boxes -d java-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d java-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d java-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d java-cmt -r<CR>='z
