if exists("loaded_alternateFile")
  finish
endif
let loaded_alternateFile = 1

let s:fileSep="?"

" functions {{{1

" function! AddAlternateExtensionMapping	{{{2
function! AddAlternateExtensionMapping(extension, alternates)
  " let v:errmsg = ""
  " silent! echo g:alternateExtensions_{a:extension}
  " if (v:errmsg != "")
  "   let g:alternateExtensions_{a:extension} = a:alternates
  " endif
  let g:alternateExtensions_{a:extension} = a:alternates
endfunction
" }}}2

" function! <SID>GetNthItemFromList	{{{2
"--------------------------------------------------------------------
" Purpose: get nth item from the list
" Args:
" 	sep: the separator in list
" 	list: the list (extension spec, file paths) to iterate
" 	n: the index to get
"--------------------------------------------------------------------
function! <SID>GetNthItemFromList(sep,list, n) 
  let itemStart = 0
  let itemEnd = -1
  let pos = 0
  let item = ""
  let i = 0
  while (i != a:n)
    let itemStart = itemEnd + 1
	let itemEnd = match(a:list, a:sep , itemStart)
    let i = i + 1
    if (itemEnd == -1)
      if (i == a:n)
	let itemEnd = strlen(a:list)
      endif
      break
    endif
  endwhile 
  if (itemEnd != -1) 
    let item = strpart(a:list, itemStart, itemEnd - itemStart)
  endif
  return item 
endfunction
" }}}2

" function! EnumerateFilesByExtension	{{{2
function! EnumerateFilesByExtension(path, baseName, extension)
  let enumeration = ""
  let extSpec = ""
  silent! let extSpec = g:alternateExtensions_{a:extension}
  if (extSpec != "") 
	let n = 1
	let done = 0
	while (!done)
	  let ext = <SID>GetNthItemFromList(',', extSpec, n)
	  if (ext != "")
		if (a:path != "")
		  let newFilename = a:path . "/" . a:baseName . "." . ext
		else
		  let newFilename =  a:baseName . "." . ext
		endif
		if (enumeration == "")
		  let enumeration = newFilename
		else
		  let enumeration = enumeration . s:fileSep . newFilename
		endif
	  else
		let done = 1
	  endif
	  let n = n + 1
	endwhile
  endif
  return enumeration
endfunction
" }}}2

" function! AlternateFile	{{{2
function! AlternateFile(splitWindow, ...)
  let extension   = fnamemodify((expand("%:p")), ":t:e")
  let baseName    = substitute(expand("%:t"), "\." . extension . '$', "", "")
  let currentPath = expand("%:p:h")

  if (a:0 != 0)
	let newFullname = currentPath . "/" .  baseName . "." . a:1
	call <SID>FindOrCreateBuffer(newFullname, a:splitWindow)
  else
	let allfiles = ""
	if (extension != "")
	  let allfiles = EnumerateFilesByExtension(currentPath, baseName, extension)
	endif

	if (allfiles != "") 
	  let bestFile = ""
	  let bestScore = 0
	  let score = 0
	  let n = 1

	  let onefile = <SID>GetNthItemFromList(s:fileSep, allfiles, n)
	  let bestFile = onefile
	  while (onefile != "" && score < 2)
		let score = <SID>BufferOrFileExists(onefile)
		if (score > bestScore)
		  let bestScore = score
		  let bestFile = onefile
		endif
		let n = n + 1
		let onefile = <SID>GetNthItemFromList(s:fileSep, allfiles, n)
	  endwhile

	  call <SID>FindOrCreateBuffer(bestFile, a:splitWindow)

	else
	  echo "No alternate file/buffer available"
	endif
  endif
endfunction
" }}}2

" function! <SID>BufferOrFileExists	{{{2
function! <SID>BufferOrFileExists(fileName)
  let result = 0
  let bufName = fnamemodify(a:fileName,":t")
  let memBufName = bufname(bufName)
  if (memBufName != "")
	let memBufBasename = fnamemodify(memBufName, ":t")
	if (bufName == memBufBasename)
	  let result = 2
	endif
  endif

  if (!result)
	let result  = bufexists(bufName) || bufexists(a:fileName) || filereadable(a:fileName)
  endif
  return result
endfunction
" }}}2

" function! <SID>FindOrCreateBuffer	{{{2
function! <SID>FindOrCreateBuffer(filename, doSplit)
  let bufName = bufname(a:filename)
  let bufFilename = fnamemodify(a:filename,":t")

  if (bufName == "")
	let bufName = bufname(bufFilename)
  endif

  if (bufName != "")
	let tail = fnamemodify(bufName, ":t")
	if (tail != bufFilename)
	  let bufName = ""
	endif
  endif

  let splitType = a:doSplit[0]
  let bang = a:doSplit[1]
  if (bufName == "")
	let v:errmsg=""
	if (splitType == "h")
	  silent! execute ":split".bang." " . a:filename
	elseif (splitType == "v")
	  silent! execute ":vsplit".bang." " . a:filename
	else
	  silent! execute ":e".bang." " . a:filename
	endif
	if (v:errmsg != "")
	  echo v:errmsg
	endif
  else
	let bufWindow = bufwinnr(bufName)
	if (bufWindow == -1) 
	  let v:errmsg=""
	  if (splitType == "h")
		silent! execute ":sbuffer".bang." " . bufName
	  elseif (splitType == "v")
		silent! execute ":vert sbuffer " . bufName
	  else
		silent! execute ":buffer".bang." " . bufName
	  endif
	  if (v:errmsg != "")
		echo v:errmsg
	  endif
	else
	  execute bufWindow."wincmd w"
	  if (bufWindow != winnr()) 
		let v:errmsg=""
		if (splitType == "h")
		  silent! execute ":split".bang." " . bufName
		elseif (splitType == "v")
		  silent! execute ":vsplit".bang." " . bufName
		else
		  silent! execute ":e".bang." " . bufName
		endif
		if (v:errmsg != "")
		  echo v:errmsg
		endif
	  endif
	endif
  endif
endfunction
" }}}2

" }}}1

" mapping {{{
comm! -nargs=? -bang A call AlternateFile("n<bang>", <f-args>)
nnoremap <M-'> :A<cr>
comm! -nargs=? -bang AS call AlternateFile("h<bang>", <f-args>)
comm! -nargs=? -bang AV call AlternateFile("v<bang>", <f-args>)
" }}}

" Extension Mapping {{{
"call AddAlternateExtensionMapping('h',"cc,c,cpp,cm,tcc")
call AddAlternateExtensionMapping('p',"web")
call AddAlternateExtensionMapping('web',"p")

" call AddAlternateExtensionMapping('w',"c")

call AddAlternateExtensionMapping('js',"html")
call AddAlternateExtensionMapping('html',"js")

call AddAlternateExtensionMapping('h',"cpp,c,cc,cpp,cm,tcc")
" call AddAlternateExtensionMapping('H',"cc,c,cpp,cm,tcc")
call AddAlternateExtensionMapping('H',"c,cc,cpp,cm,tcc")
" call AddAlternateExtensionMapping('c',"w,h")
call AddAlternateExtensionMapping('c',"h")
call AddAlternateExtensionMapping('cpp',"h,cbp,hpp")
call AddAlternateExtensionMapping('hpp',"cpp")
call AddAlternateExtensionMapping('cc',"h")
call AddAlternateExtensionMapping('tcc',"h")
call AddAlternateExtensionMapping('class',"java")
call AddAlternateExtensionMapping('cbp',"cpp")

"add for lex and yacc
call AddAlternateExtensionMapping('l',"y")
call AddAlternateExtensionMapping('y',"l")

"cm is added for supporting 'baci'
call AddAlternateExtensionMapping('cm',"h")
" }}}

" set vim: fdm=marker:
