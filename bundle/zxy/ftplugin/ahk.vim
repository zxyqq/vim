if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer>  ,mc !!boxes -d ahk-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d ahk-cmt<CR>='z
nnoremap <buffer>  ,xc !!boxes -d ahk-cmt -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d ahk-cmt -r<CR>='z

nnoremap <buffer> <Leader>hr  :call File_Template_Comment ('header')<cr>
setlocal comments=n:;,b:;
setlocal formatoptions+=o
setlocal fenc=cp936
setlocal shiftwidth=8

inoremap <buffer> <Tab> <C-R>=SuperCleverTab()<cr>

let b:match_words = '#IfWinActive:#if,#IfWinNotActive:#if'
