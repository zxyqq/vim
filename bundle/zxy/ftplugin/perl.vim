"use for insert template in makefile. so put at C:\Program Files\Vim\vimfiles\ftplugin\
"not in C:\Program Files\Vim\vim64\ftplugin\make.vim
if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1
set ff=unix

let mapleader = '\'

nnoremap <buffer> <Leader>chr  :call File_Template_Comment ('hheader')<cr>
nnoremap <buffer> <Leader>hhr  :call File_Template_Comment ('hheader')<cr>

inoremap <buffer> <Leader>chr  <Esc>:call File_Template_Comment ('hheader')<cr>
inoremap <buffer> <Leader>hhr  <Esc>:call File_Template_Comment ('hheader')<cr>
