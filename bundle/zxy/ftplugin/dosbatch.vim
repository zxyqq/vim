if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

nnoremap <buffer>  ,mc !!boxes -d dosbatch-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d dosbatch-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d dosbatch-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d dosbatch-cmt -r<CR>='z

"setlocal makeprg=cmd\ /c
