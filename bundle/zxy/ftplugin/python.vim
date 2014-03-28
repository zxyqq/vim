if !exists("b:did_python_indent")
  let b:did_python_indent=1
endif

setlocal softtabstop=4
setlocal shiftwidth=4
setlocal tabstop=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
setlocal makeprg=python

" nnoremap <buffer> gj :call MakeIt()<cr>

nnoremap <buffer> <silent> gi :let @/="import"<cr>ggn
nnoremap <buffer> <Leader>hr  :call File_Template_Comment ('header')<cr>
setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
" setlocal fdm=indent
setlocal fdm=manual

" put the following code in directory ftplugin/python.vim
" " function! s:SetTag() {{{
" function! s:SetTag()
"   setlocal tags&vim
"   let b:tagsv=&l:tags
"
"   call Python_HasSysPath()
"   let &l:tags=b:tagsv
" endf
" " }}}

" " func! Python_HasSysPath() {{{
" func! Python_HasSysPath()
"   normal! mt
"   execute("0")
"   let il=search('^sys.path\s\{0,}+=', 'W')
"   while il>0
"     let remain=getline(il)
"     while(remain!="")
"       let pos = GetPatternPos(remain, ",")
"       let part = strpart(remain, 0, pos)
"       let path = matchstr(remain, "\'[^']*\'")
"       " 剥离两个单引号
"       let path = strpart(path, 1, strlen(path)-2)
"       let b:tagsv = b:tagsv . g:TagSep . path . g:FS . 'tags'
"       let remain = strpart(remain,pos+1)
"     endwhile
"
"     normal! j
"     let il=search('^\s\{0,}import', 'W')
"   endwhile
"
"   normal! `t
" endf
" " }}}

" call SetTag()
" unmap <buffer> <2-LeftMouse>
" unmap <2-LeftMouse>
" set mouse=n
nnoremap <silent> <buffer> <2-LeftMouse> :set noic<cr>:let @/='\<'.substitute(expand("<cword>"), '^t_', '', '').'\>'<cr>:exe "tag ". expand("<cword>")<cr>
" nnoremap <buffer> <2-LeftMouse> :exe "tag ". expand("<cword>")<CR>
" nnoremap <buffer> <RightMouse> :call GotoParentdirOrBack()<cr>
nnoremap <buffer> <RightMouse> :call GotoParentdirOrHead()<cr>
" nnoremap <buffer> <M-8> :set noic<cr>:let @/=expand("<cword>") <cr>
" nnoremap <buffer> <MiddleMouse> <LeftMouse>:set noic<cr>:let @/=substitute(expand("<cword>"), '^t_', '', '')<cr>
" nnoremap <buffer> <M-8> :set noic<cr>:let @/=substitute(expand("<cword>"), '^t_', '', '')<cr>
nnoremap <buffer> <MiddleMouse> <LeftMouse>:set noic<cr>:let @/='\<'.substitute(expand("<cword>"), '^t_', '', '').'\>'<cr>
nnoremap <buffer> <M-8> :set noic<cr>:let @/='\<'.substitute(expand("<cword>"), '^t_', '', '').'\>'<cr>
nnoremap <buffer> gf gf
cnoremap <buffer> <C-x>c :!ctags *.py
" nnoremap <silent> <buffer> K :call MyShowPyDoc()<CR>
nnoremap <buffer> <silent> <A-/> :call SwitchSI()<cr>

nnoremap <buffer> gd gd 
