"use for insert template in makefile. so put at C:\Program Files\Vim\vimfiles\ftplugin\
"not in C:\Program Files\Vim\vim64\ftplugin\make.vim
if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

let mapleader = '\'

" nnoremap <buffer> <Leader>chr  :call File_Template_Comment ('mheader')<cr>:let @/="xxx"<cr>:%s/xxx/
" nnoremap <buffer> <Leader>cme  :call File_Template_Comment ('method')<cr>:let @/="xxx"<cr>:%s/xxx/
"
" inoremap <buffer> <Leader>chr  <Esc>:call File_Template_Comment ('mheader')<cr>:let @/="xxx"<cr>:%s/xxx/
" inoremap <buffer> <Leader>cme  <Esc>:call File_Template_Comment ('method')<cr>:let @/="xxx"<cr>:%s/xxx/

nnoremap <buffer> <Leader>chr  :call File_Template_Comment ('header')<cr>
nnoremap <buffer> <Leader>cme  :call File_Template_Comment ('method')<cr>

inoremap <buffer> <Leader>chr  <Esc>:call File_Template_Comment ('header')<cr>
inoremap <buffer> <Leader>cme  <Esc>:call File_Template_Comment ('method')<cr>

nnoremap <buffer>  ,mc !!boxes -d donote<CR>==
vnoremap <buffer>  ,mc mz!boxes -d donote<CR>='z
nnoremap <buffer>  ,xc !!boxes -d donote -r<CR>==
vnoremap <buffer>  ,xc mz!boxes -d donote -r<CR>='z
