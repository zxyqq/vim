if exists("b:did_zxy_plugin")
  finish
endif

let mapleader = '\'

nnoremap <buffer>  ,mc !!boxes -d pound-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d pound-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d pound-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d pound-cmt -r<CR>='z

nnoremap <buffer> <Leader>hr  :call File_Template_Comment ('header')<cr>

