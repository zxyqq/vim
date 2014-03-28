" Vim plugin
" Language:	Vim
" Maintainer:	zxy <zxycscj@126.com>
" Last Change:	2009 Jun 08

if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer> <Leader>vh :call File_Template_Comment ('header')<cr>
nnoremap <buffer> <Leader>vf :call File_Template_Comment ('function')<cr>

inoremap <buffer> <Leader>vh <Esc>:call File_Template_Comment ('header')<cr>
inoremap <buffer> <Leader>vf <Esc>:call File_Template_Comment ('function')<cr>
cnoremap <buffer> <C-x>c :!ctags -R *.vim

setlocal foldmethod=marker
setlocal shiftwidth=2

nnoremap <buffer> ,mc !!boxes -d vim-cmt<CR>==
vnoremap <buffer> ,mc mz!boxes -d vim-cmt<CR>='z
nnoremap <buffer> ,xc !!boxes -d vim-cmt -r<CR>==
vnoremap <buffer> ,xc mz!boxes -d vim-cmt -r<CR>='z
nnoremap <buffer> ,xm !!boxes -d vim-cmt -r<CR>==
vnoremap <buffer> ,xm mz!boxes -d vim-cmt -r<CR>='z

