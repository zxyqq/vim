if exists("b:did_zxy_plugin")
  finish
endif

let mapleader = '\'

nnoremap <buffer> <Leader>hr  :call File_Template_Comment ('header')<cr>
setlocal cindent shiftwidth=4
setlocal expandtab
setlocal softtabstop=8
setlocal formatoptions+=o
setlocal textwidth=80

nnoremap <buffer>  ,mc !!boxes -d pound-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d pound-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d pound-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d pound-cmt -r<CR>='z
