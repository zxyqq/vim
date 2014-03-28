if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer> <Leader>cfr  :call File_Template_Comment ('frame')<cr>
nnoremap <buffer> <Leader>ccl  :call File_Template_Comment ('class')<cr>
nnoremap <buffer> <Leader>chr  :call File_Template_Comment ('cheader')<cr>
nnoremap <buffer> <Leader>hhr  :call File_Template_Comment ('hheader')<cr>
nnoremap <buffer> <Leader>cme  :call File_Template_Comment ('method')<cr>

inoremap <buffer> <Leader>cfr  <Esc>:call File_Template_Comment ('frame')<cr>
inoremap <buffer> <Leader>ccl  <Esc>:call File_Template_Comment ('class')<cr>
inoremap <buffer> <Leader>chr  <Esc>:call File_Template_Comment ('cheader')<cr>
inoremap <buffer> <Leader>hhr  <Esc>:call File_Template_Comment ('hheader')<cr>
inoremap <buffer> <Leader>cme  <Esc>:call File_Template_Comment ('method')<cr>
nnoremap <buffer> <Leader>cfm  :call File_Template_Comment ('cmain')<cr>

inoremap <buffer> <Leader>cfr  <Esc>:call File_Template_Comment ('frame')<cr>
inoremap <buffer> <Leader>ccl  <Esc>:call File_Template_Comment ('class')<cr>
inoremap <buffer> <Leader>chr  <Esc>:call File_Template_Comment ('cheader')<cr>
inoremap <buffer> <Leader>hhr  <Esc>:call File_Template_Comment ('hheader')<cr>
inoremap <buffer> <Leader>cme  <Esc>:call File_Template_Comment ('method')<cr>
inoremap <buffer> <Leader>cfm  <Esc>:call File_Template_Comment ('cmain')<cr>

setlocal kp=man
noremap <buffer> <2-LeftMouse> :exe "tag ". expand("<cword>")<CR>
" nnoremap <buffer> <RightMouse> :call GotoParentdirOrHead()<cr>
setlocal foldlevel=99
setlocal foldmethod=indent


nnoremap <buffer>  ,mm !!boxes -d c-cmt<CR>==
vnoremap <buffer>  ,mm mz!boxes -d c-cmt<CR>='z
nnoremap <buffer>  ,xm !!boxes -d c-cmt -r<CR>==
vnoremap <buffer>  ,xm mz!boxes -d c-cmt -r<CR>='z

nnoremap <buffer>  ,mc !!boxes -d c-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d c-cmt<CR>='z
nnoremap <buffer>  ,xc :call Delcomment()<cr>
vnoremap <buffer>  ,xc :call Delcomment()<cr>

setlocal cindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab
noremap <buffer> <2-LeftMouse> :call MyDoubleClick()<CR>
setlocal cino=g0

" nnoremap <buffer> 'd :call ExecuteIt()<cr>
nnoremap <buffer> <silent> gi :let @/="include"<cr>ggn
