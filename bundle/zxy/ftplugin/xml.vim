if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer> <Leader>cff  :call File_Template_Comment ('firefox')<cr>
nnoremap <buffer> <Leader>cbp  :call File_Template_Comment ('codeBlockPrj')<cr>:let @/="cpp"<cr>
setlocal foldmethod=indent
