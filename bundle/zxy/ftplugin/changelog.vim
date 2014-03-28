if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

nnoremap <buffer>  ,mc !!boxes -d donote<CR>==
vnoremap <buffer>  ,mc mz!boxes -d donote<CR>='z
nnoremap <buffer>  ,xc !!boxes -d donote -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d donote -r<CR>='z
setlocal tw=0
