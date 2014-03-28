" Vim plugin
" Language:	Vim
" Maintainer:	zxy <zxycscj@126.com>
" Last Change:	2009 Jul 07

if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1
map <buffer> * *N
map <buffer> # #
nnoremap <buffer> <silent> gi :silent! exec('/^\s\{0,}#include')<cr>

nmap <buffer> ,mc !!boxes -d c-cmt<CR>==
vmap <buffer> ,mc mz!boxes -d c-cmt<CR>='z
nmap <buffer> ,xc !!boxes -d c-cmt -r<CR>==
vmap <buffer> ,xc mz!boxes -d c-cmt -r<CR>='z
setlocal kp=man
nnoremap <buffer> <silent> gi :let @/="include"<cr>ggn
