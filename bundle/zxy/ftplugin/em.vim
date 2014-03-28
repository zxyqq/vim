if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

setlocal fdm=indent

setlocal cindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab

nnoremap <buffer>  ,mc !!boxes -d c-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d c-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d c-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d c-cmt -r<CR>='z
setlocal fenc=cp936
