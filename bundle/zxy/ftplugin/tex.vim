if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer> <Leader>hr  :call File_Template_Comment('header')<cr>
nnoremap <buffer> <Leader>hr  <Esc>:call File_Template_Comment('header')<cr>
