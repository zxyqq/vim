if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1

let mapleader = '\'

nnoremap <buffer> <Leader>cm  :call File_Template_Comment ('cmain')<cr>

inoremap <buffer> <Leader>cm  <Esc>:call File_Template_Comment ('cmain')<cr>

" setlocal tags+=D:\skill\programming\c\header\usr\include\tags

nnoremap <buffer> <silent> <A-/> :call SwitchSI()<cr>

nnoremap <buffer> <RightMouse> <C-t>
setlocal foldlevel=99
nnoremap <buffer> gd gd 

setlocal iskeyword+=_
nnoremap <buffer> <silent> gi :let @/="include"<cr>ggn
setlocal foldmethod=indent
setlocal foldlevel=99

nnoremap <buffer>  ,mm !!boxes -d c-cmt<CR>==
vnoremap <buffer>  ,mm mz!boxes -d c-cmt<CR>='z
nnoremap <buffer>  ,xm !!boxes -d c-cmt -r<CR>==
vnoremap <buffer>  ,xm mz!boxes -d c-cmt -r<CR>='z

nnoremap <buffer>  ,mc !!boxes -d c-cmt<CR>==
vnoremap <buffer>  ,mc mz!boxes -d c-cmt<CR>='z
nnoremap <buffer>  ,xc :call Delcomment()<cr>
vnoremap <buffer>  ,xc :call Delcomment()<cr>

" nnoremap <buffer>  ,mc :call AddCommentPart()<cr>

if !exists("g:commentpat")
  let g:commentpat = '\([ \t]\{3,}\)\@<=[^ \t].*$'
endif

func! AddCommentPart()
  let curline=getline(".")
  " delete tail blank
  let curline = substitute(curline, "[ \t]*$", "", "")
  let idx=Strridx(curline, g:commentpat)
  if (idx == -1)
    silent execute("normal ,mm")
    return
  endif

  let prestr=strpart(curline,0,idx)
  let endstr=strpart(curline,idx)
  let newline= prestr . '/* ' . endstr. ' */'
  put=newline
  normal k
  normal dd
endf

func! Delcomment()
  let curtext = getline(".")
  let newtext = substitute(curtext, '\/\*\s*\|\s*\*\/', "", "g")
  put=newtext
  normal k
  normal dd
endf

func! Strridx(str,pat)
  let str=a:str
  let pat=a:pat
  let idx=match(str,pat)
  if (idx == -1)
    return -1
  endif

  let cur=0
  while(idx!=-1)
    let str=strpart(str,idx)
    let cur=cur+idx
    let idx = match(str,pat)
  endw

  return cur
endf

setlocal cindent
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal expandtab
" noremap <buffer> <2-LeftMouse> :exe "tag ". expand("<cword>")<CR>
" noremap <buffer> <2-LeftMouse> :call MyDoubleClick()<CR>
