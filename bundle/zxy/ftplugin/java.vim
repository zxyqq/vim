if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

cnoremap <buffer> <C-x>c :!ctags -R *
nnoremap <buffer> <Leader>hr  :call File_Template_Comment ('header')<cr>

" func! Java_HasImport() {{{
func! Java_HasImport()
  normal! mt
  normal G$

  let flags = "w"

  let pat='\s\{0,}import'. '\( static \)*'.'\s\{0,}'
  let b:lastTag = ""
  while (search('^\s\{0,}import ', flags) > 0)
    let remain=getline(".")
    " 跳过import java.*
    if remain =~ '^\s\{0,}import java\.'
      let flags = "W"
      continue
    endif

    while(remain!="")
      let pos = GetPatternPos(remain, ";")
      let part = strpart(remain, 0, pos)
      let remain = strpart(remain,pos+1)

      let dir = substitute(part, pat, '', '')
      let dir = substitute(dir, '\.\*\s\{0,}', '', '')
      let dir = substitute(dir, '\.', g:WinFS, 'g')

      " let tail = dir . g:WinFS . 'tags'

      let remainDir = g:Java_Classpath
      while(remainDir!="")
	let pos=GetPatternPos(remainDir, ";")
	let checkDir=strpart(remainDir, 0, pos)
	let remainDir=strpart(remainDir,pos+1)
	" ignore the current directory
	if checkDir != "."
	  let checkDir = substitute(checkDir, '[\/]\{0,}$', g:WinFS, '')
	  let TagDir = checkDir . dir
	  if isdirectory(TagDir)
	    let fn=TagDir . g:WinFS . 'tags'
	    if filereadable(fn)
	      if (fn == b:lastTag)
		let flags = "W"
		continue
	      else
		let b:tagsv = b:tagsv . g:TagSep . fn
		let b:lastTag = fn
		break
	      endif
	    endif
	  else
	    " 检测是否是import指定到了目录下的某个具体的class
	    let TagDir = substitute(TagDir, '\\[^\/]\{1,}$', '', '')
	    if isdirectory(TagDir)
              let fn=TagDir . g:WinFS . 'tags'
              if filereadable(fn)
		if (fn == b:lastTag)
		  continue
		endif
		let b:tagsv = b:tagsv . g:TagSep . fn
		let b:lastTag = fn
		break
              endif
	    endif
	  endif
	endif
      endwhile
    endwhile
    let flags = "W"
  endwhile
  normal! `t
endf
" }}}

function! s:SetTag()
  setlocal tags&vim
  let b:tagsv=&l:tags
  if exists("g:Java_Default_Tags") && g:Java_Default_Tags
    let b:tagsv = b:tagsv . g:TagSep . g:Java_Default_Tags
  endif
  call Java_HasImport()
  let &l:tags=b:tagsv
endf

call s:SetTag()
" vim: set fdm=marker:
