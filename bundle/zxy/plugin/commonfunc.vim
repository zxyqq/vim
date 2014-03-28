if exists("loaded_commonfunc")
  finish
endif
let loaded_commonfunc=1

" variables {{{

if !exists("g:ValidVolumePat")
  let g:ValidVolumePat='[a-z]'
endif

if !exists("g:FS")
  if has("win32") && &ssl==0
    let g:FS = '\'
  else
    let g:FS = '/'
  endif
endif

if has("win32")
  let s:escfilename = '%#!*?&'
else
  "let s:escfilename = '%#!*? '
  "same as foo.vim
  let s:escfilename = "%#!*? ')([]&"
endif
"}}}

" functions {{{
" function! Warning_Msg  {{{
function! Warning_Msg(msg)
  echohl WarningMsg
  "echomsg a:msg
  echo a:msg
  echohl None
endfunction
" }}}

" function! WinPath  {{{
function! WinPath(p)
  " return substitute(a:p,'/','\\','g')
  return TrimLastSlash(substitute(a:p,'/','\\','g'))
endfunction
" }}}

" function! UnixPath  {{{
function! UnixPath(p)
  " return substitute(a:p,'\\','\/','g')
  return TrimLastSlash(substitute(a:p,'\\','\/','g'))
endfunction
" }}}

" function! StripEscape  {{{
function! StripEscape(string,pat)
  "return substitute(a:string, '\\\'.a:pat, a:pat, 'g')
  return substitute(a:string, '\\'.'\('.a:pat.'\)', '\1', 'g')
endfunction
" }}}

" function! Path  {{{
function! Path(p)
  if has("win32")&&&ssl==0
    return WinPath(a:p)
  else
    "unix stripped the backslash
    " let ret = StripEscape(a:p, '[[\] \/()&]')
    " return UnixPath(ret)
    return UnixPath(a:p)
  endif
endfunction
" }}}

" function! s:PathEqual  {{{
function! s:PathEqual(a,b)
  let fa=substitute(a:a, '[\/]$', '', '')
  let fb=substitute(a:b, '[\/]$', '', '')
  return fa==fb
endfunction
" }}}

" function! FormatPathWithoutDot  {{{
"--------------------------------------------------------------------
" FormatPathWithoutDot
"
" purose: uniform the path without "." and ".." for subsequent use
" arguments: @path: path need to be uniformed
" return: path without "." and ".."
"--------------------------------------------------------------------
function! FormatPathWithoutDot(path)
  if a:path =~ '^\\\\'
    return a:path
  endif
  " let ret = StripEscape(a:path, '[[\] \/()]')
  let ret = a:path
  let ret = UnixPath(ret)

  if (!IsAbsPath(a:path))
    return a:path
  endif

  let pat1='[\/]\.\?[\/]'
  let ret= substitute(ret, pat1, '/', 'g')

  let pat2='\/[^/]\+[\/]\.\.\([\/]\|$\)'
  while ret =~ pat2
    let ret= substitute(ret, pat2, '/', '')
  endwhile

  " other cases left:
  let ret= substitute(ret,'/\.$', '', '')
  return Path(ret)
endfunction
" }}}

" function! s:FullPathComplete  {{{
function! s:FullPathComplete(p)
  if has("win32")
    if a:p !~ '^\a:'
      return GetDirectoryName().g:FS.a:p
    endif
  elseif a:p !~ '^\/\a'
    return GetDirectoryName().g:FS.a:p
  endif
  return a:p
endfunction
" }}}

" function! AddLastSlash  {{{
function! AddLastSlash(p)
  return TrimLastSlash(a:p).g:FS
endfunction
" }}}

" function! TrimLastSlash  {{{
function! TrimLastSlash(p)
  " return substitute(a:p, '\'.g:FS.'$', '', '')
  return substitute(a:p, '\([^:]\)'. '\'. g:FS. '$', '\1', '')
endfunction
" }}}

" function! WindowExistNo  {{{
function! WindowExistNo(p)
  let fn=s:FullPathComplete(a:p)
  let fn=FormatPathWithoutDot(fn)
  let fn=TrimLastSlash(fn)
  let winnum=bufwinnr(fn)
  if winnum == -1
    let fn=AddLastSlash(fn)
    let winnum=bufwinnr(fn)
  endif
  if winnum == -1
    return -1
  endif
  let bnr= bufnr(fn)
  let bname=fnamemodify(bufname(bnr), ':p')
  if s:PathEqual(bname,fn)==1
    return winnum
  endif
  return -1
endf
" }}}

" function! GetDirectoryName  {{{
"escape for filename. Be careful when it is invoked.
"avoid to escape twice
"delete the escape here.
function! GetDirectoryName(...)
 if &ft == "nerdtree"
    let node = g:NERDTreeFileNode.GetSelected()
    if empty(node)
      normal P
      let node = g:NERDTreeFileNode.GetSelected()
    endif
    if empty(node)
      return ""
    endif
    let path = node.path
    if path.isDirectory	&& node.isOpen
      let b:curdir =  path.drive . g:FS . join(path.pathSegments, g:FS)
    else
      let b:curdir =  path.drive . g:FS . join(path.pathSegments[0:-2], g:FS)
    endif
    return b:curdir
  endif

  if a:0 == 0
    if !exists("b:curdir")||b:curdir==''||!isdirectory("b:curdir")
      let filename = expand("%:p")
    else
      "return escape(b:curdir, s:escfilename)
      "for the escape is done in its first time
      return b:curdir
    endif
  elseif a:0 == 1
    let filename = a:1
  endif

  if has("win32")&& &ssl==0
    let ret=substitute(filename, '\\[^\\]*$', '', '')
  else
    let filename=substitute(filename, '\\\([^ ]\)', '/\1', 'g')
    let ret=substitute(filename, '/[^/]*$', '', '')
  endif
  "let ret = escape(ret, s:escfilename)
  if (a:0==0)
    let b:curdir=ret
  endif
  return ret
endfunction
" }}}

" function! s:ExecuteBashfile  {{{
function! s:ExecuteBashfile()
  if exists("b:maxFileLen")
    let fname = getline(".")
  else
    let fname = expand("%:p:t")
  endif

  if fname =~? '\/$'
    call Warning_Msg("only file support!")
    return
  endif

  let suffix = fnamemodify(fname, ":t:e")
  if suffix == "sh"
    echohl WarningMsg
    let fname = input("bash -x ", fname)
    echohl None
    if fname == ""
      return
    endif
    let cmd = "bash -x " . fname
    if has("win32")
      execute('silent !start '.cmd)
    else
      let cmd ='!' . cmd
    endif
  endif
endf
" }}}

" function! ExecuteCurLine  {{{
function! EmbraceDQ(name)
  return '"'.a:name.'"'
endf

function! ExecuteCurLine(prg, prompt)
  let urlpat= '\(http:\/\/\|https:\/\/\|www\.\|ftp:\|ftp\.\)'.'[^" ]*'
  let url = matchstr(getline("."), urlpat)
  if url== ""
    let key = substitute(getline("."), '^[ \t]\+',"","")
    let key = substitute(key, ' ', '+', 'g')
    let url = 'http://www.google.com.hk/search?q='.key.'&ie=utf-8&oe=utf-8&aq=t'
  endif
  let options="-new-tab -url"

  if a:prompt == 1
    let url = input("give your text: ", url)
  endif

  if url== ""
    return
  endif

  if has("win32")
    let cmd = 'silent !start '. a:prg. " " . options. " " . EmbraceDQ(url)
    execute cmd
    echohl WarningMsg
    echo "success!"
    echohl None
    return
  endif

  let @_=system(EmbracePath(a:prg." ".options." ".EmbraceDQ(url)))
  echohl WarningMsg
  if (v:shell_error)
    echo v:shell_error
  else
    echo "success!"
  endif
  echohl None
endf
" }}}

" function! IsAbsPath  {{{
function! IsAbsPath(fn)
  if has("unix")
    return ( a:fn[0]=='/' ) || ( a:fn[0]=='~' ) || (a:fn =~ '^$HOME')
  elseif has("win32")
    if a:fn =~ '\/\/' ||
	  \ a:fn =~ '\\\\'
      return 1
    endif
    if exists("g:ValidVolumePat")
      return a:fn =~? '^' . g:ValidVolumePat . ':[\/]'
    else
      return a:fn =~? '^[a-z]:[\/]'
    endif
  endif
endf
" }}}

" function! EmbracePath  {{{
"--------------------------------------------------------------------
" EmbracePath
" 	if the file name contains double quote \", we embrace it with
" 	single quotes.
" 	if the file name contains single quote \', we embrace it with
" 	double quotes.
"--------------------------------------------------------------------
function! EmbracePath(fn)
  "prefer the '"'
  if a:fn =~ '"'
    if a:fn =~ "'"
      return
    endif
    let goodquote="'"
  else
    let goodquote='"'
  endif
  return goodquote.a:fn.goodquote
endfunction
" }}}

" function! GetPatternPos  {{{
function! GetPatternPos(str, sep)
  let pos=stridx(a:str, a:sep)
  if(pos==-1)
    return strlen(a:str)
  else
    return pos
  endif
endf
" }}}

" func! ExecuteString  {{{
func! ExecuteString(p)
  let s=substitute(a:p, '^\s\{0,}', '', '')
  let bneedouput = 1
  " 如果行尾有行连接符\就进行while循环
  " 但如果文件末行就是以\结尾
  while s =~ '\\\s\{0,}$'
    let s = substitute(s,'\\\s\{0,}$', ' ','')
    if line(".") == line("$")
      break
    endif
    normal j
    " 跳过注释行这里仅支持#
    while(getline(".") =~# '^\s\{0,}[#]')
      normal j
    endwhile
    " 去掉行首空行，其实也可以去掉
    let s = s . substitute(getline("."), '^\s\{0,}', '', '')
  endwhile

  silent execute('lcd ' . GetDirectoryName())

  if s =~? '^\[\?\(HKEY_CLASSES_ROOT\|HKEY_CURRENT_USER\|HKEY_LOCAL_MACHINE\|HKCU\|HKLM\|HKCR\)]\?'
    " let s = substitute(s, "HKEY_CURRENT_USER", "HKCU", "")
    " let s = substitute(s, "HKEY_LOCAL_MACHINE", "HKLM", "")
    let s = substitute(s, '\[\|\]', "", "g")
    if s !~? '\s*regjump'
      let s = 'D:\PortableApps\sysinternals\RegJump\v1.01\regjump.exe ' . s
    endif
    let bneedouput = 0
  endif

  if s =~? ">"
    if executable('col')
      let news = substitute(s, ">", " |col -b >", 'g')
      let cmd = "!". news
    else
      let cmd = "!". s
    endif
    silent execute cmd
    return
  endif

  let l:errormsg=""
  let l:errormsg=system(s)
  if ((l:errormsg!="") && (1 == bneedouput))
    put=l:errormsg
    return
  endif
endf
" }}}

" function! Foo_Exe_Cmd_No_Acmds  {{{
function! Foo_Exe_Cmd_No_Acmds(cmd)
  let old_eventignore = &eventignore
  set eventignore=all
  exe a:cmd
  let &eventignore = old_eventignore
  return
endfunction
" }}}

" function! G_explFileHandlerWin32(fn) {{{
function! G_explFileHandlerWin32(fn)
    exec 'silent !start rundll32 url.dll,FileProtocolHandler "'
	  \ . escape(a:fn, '%#!') . '"'
endfunction
" }}}

" 针对不同的文件的make程序
let g:makeprg_ext_bat = "cmd"
let g:makeprg_ext_bat_options = "/c"
let g:makeprg_ext_sh = "bash"
let g:makeprg_ext_c = "gcc"
let g:makeprg_ext_cc = "g++"
let g:makeprg_ext_java = "javac"
let g:makeprg_ext_java_options = "-g"
let g:makeprg_ext_py = "python"

let g:qf_higher = 1

" func! GuessMakeIt() {{{1
func! GuessMakeIt()
  let save_ln=winnr()

  let fname = fnamemodify(Foo_GetFileName(),":t")
  " 处理makefile文件
  if fname =~? "makefile"
    let target = input('make  -f ' . fname . ' ')
    if (target != "")
      let cmd = 'make  -f ' . fname . ' ' . target
    else
      return
    endif
    silent execute(cmd)
    " 打开关闭quickfix窗口为的是得到窗口有效行数
    silent execute('botright cope')
    let qkln=line("$") + g:qf_higher
    silent execute('cclose')
    silent execute('botright cope '. qkln)
    silent execute(save_ln . ' wincmd w')
    return
  endif

  let extension = fnamemodify(fname, ":e")
  if !exists('g:makeprg_ext_'.extension)
    call Warning_Msg('g:makeprg_ext_'.extension.' not defined!')
    return
  endif

  let &makeprg = g:makeprg_ext_{extension}

  if exists('g:makeprg_ext_'.extension.'_options')
    let options = g:makeprg_ext_{extension}_options
  else
    let options = ''
  endif

  "checking existence of Makefile {{{2
  "using glob consult explorer.vim
  let candidate = b:curdir.g:FS."[mM][aA][kK][eE][fF][iI][lL][eE]"
  let files =  glob(candidate)
  let filebase  = ""
  if files != ""
    let filebase = substitute(files, '\(.*\/\)\([^\/]\+\)', '\2', '')
  else
    let candidate = b:curdir.g:FS."*.mak"
    let files =  glob(candidate)
    if files != ""
      let filebase = substitute(files, '\(.*\/\)\([^\/]\+\)', '\2', '')
    endif
  endif
  " Makefile }}}2

  if (filebase=="") "{{{2
    if ("c" == &ft)
      let basename = fnamemodify(fname, ":r")
      let options = " -g -o ". basename . ".exe"
    endif

    if executable(&makeprg)
      let cmd = 'make' . ' ' . options . ' ' . fname
      silent execute(cmd)
    else
      call Warning_Msg("unknown make program for *." . extension)
      return
    endif
  else
    let &makeprg = 'make'
    let basename = fnamemodify(fname, ":r")
    let target = input('make  -f ' . filebase . ' ', basename)
    if (target != "")
      let cmd = 'make  -f ' . filebase . ' ' . target
    else
      return
    endif
    silent execute(cmd)
  endif
  " }}}2


  " 打开关闭quickfix窗口为的是得到窗口有效行数
  silent execute('botright cope')
  let qkln=line("$") + g:qf_higher
  silent execute('cclose')

  silent execute('botright cope '. qkln)

  " let qfheight=line("$") + g:qf_higher
  " silent execute('cclose')
  " silent execute('botright cope ' . qfheight)
  " silent execute(g:Foo_LastWinNr . 'wincmd w')
  silent execute(save_ln . ' wincmd w')
endf
" }}}1

" function! Foo_GotoParentdir  {{{
function! Foo_GotoParentdir()
  let fn=expand("%:p")

  if !isdirectory(fn)
    let pardir = fnamemodify(fn, ":h")
  else
    let pardir = fnamemodify(fn, ":h:h")
  endif

  if &mod==0
    silent execute('silent e '. escape(pardir, s:escfilename))
  else
    call Warning_Msg("Sorry, save current file first!")
    return
  endif

endf
" }}}

" boxes 在公司时有时需要在代码右边添加注释。所以我们只需要在每行的最后一部分添
" 加上注释
if !exists("g:c_comment_start")
  let g:c_comment_start = '/*'
  let g:c_comment_end = '*/'
endif

if !exists("g:vim_comment_start")
  let g:vim_comment_start = '"'
  let g:vim_comment_end = ''
endif

func! AddCommentPart()
  let comment_pat = '\([ \t]*\)\([^ \t]*\)$'
  let newline = substitute(getline("."), comment_pat, '\1'.g:{&ft}_comment_start . ' \2 ' . g:{&ft}_comment_end, '')
  put = newline
  normal k
  d
endf

" functions }}}

"mappings {{{
map gj :call GuessMakeIt()<cr>
map 'x :call G_explFileHandlerWin32(Foo_GetFileName())<cr>
nnoremap vn :silent !start cmd.exe<cr>
cmap <M-'> :<C-U>!
" cmap <M-'> :<C-U>silent !start

" cnoremap <C-x>wg :!wget -b
" cnoremap <C-x>ba breakadd func <SNR>
cnoremap <C-x>ba breakadd func 
cnoremap <C-x>bd breakdel 
cnoremap <C-x>bl breaklist
cnoremap <C-x>ls :!ls -1R . > ls-1R
" cnoremap <C-x>c :!ctags --languages=c --langmap=c:.c.h --c-kinds=+px -R .
cnoremap <C-x>c :!ctags -IWXUNUSED+ --languages=c++ --c++-kinds=-p -R .
cnoremap <C-x>x :silent !start 
cnoremap <M-s> :<C-E><C-U><cr>:silent !start 

nnoremap S :sts <C-R>=expand("<cword>")<cr><cr>
" nnoremap K :sts <C-R>=expand("<cword>")<cr><cr>
" nnoremap el
" map vft  :silent !start lftp afj:afj@192.168.128.128<cr>
" ftp not support the username and password format in command?
map vft  :silent !start ftp debian<cr>
nnoremap vii :call ExecuteString(getline("."))<cr>

nnoremap 's :call <SID>ExecuteBashfile()<cr>
" nnoremap <silent>\x :call ExecuteCurLine("c:/Program Files/Mozilla Firefox/firefox.exe")<cr>
" nnoremap <silent>\x :call ExecuteCurLine("F:\PortableApps\FirefoxPortable\v3.6.6\FirefoxPortable.exe")<cr>
" nnoremap <silent>\x :call ExecuteCurLine("d:/PortableApps/FirefoxPortable/v3.6.8/FirefoxPortable.exe", 1)<cr>
nnoremap <silent>\x :call ExecuteCurLine("d:/skill/Apps/Firefox/firefox.exe", 1)<cr>
" nnoremap <silent>P :call ExecuteCurLine("F:/PortableApps/FirefoxPortable/v3.6.8/FirefoxPortable.exe", 0)<cr>
" nnoremap <silent>\i :call ExecuteCurLine("C:/Program Files/Internet Explorer/iexplore.exe", 1)<cr>
" nnoremap <silent>\w :call ExecuteCurLine("D:/Apps/cygwin/bin/w3m.exe")<cr>
" nnoremap <silent>vfl :call ExecuteCurLine("D:/Apps/cygwin/bin/lftp.exe")<cr>
"}}}

func! GotoParentdirOrBack()
  "if(&ft == "c")
  let v:errmsg = ""
  silent! execute "normal \<C-O>"
  if v:errmsg != ""
    call Foo_GotoParentdir()
  endif
  "else
  ""call Foo_GotoParentdir()
  "endif
endf

func! GotoParentdirOrHead()
  let v:errmsg = ""
  silent! execute "normal \<C-T>"
  if v:errmsg != ""
    0
  endif
endf

func! SwitchSI()
  let ln = line(".")
  " let fnbase = expand("%:t")
  let fn= expand("%:p")
  let cmd = "!start " . '"' . g:siprg . '"' . " -i +" . ln . ' ' . '"' . fn . '"'
  execute cmd
endf

func! MyDoubleClick()
  if expand("%:p:t") == "[Command Line]"
    nnoremap <buffer> <cr> <cr>
    silent! normal 0
    silent! normal 
    return
  endif

  if &ft == "help"
    silent! normal K
  endif

  if(WinPath($FAVOURITES) == WinPath(expand("%:p")))
    if(&mod == 1)
      silent! normal gf
    else
      silent! normal go
    endif
    return
  endif

  let isf_save=&isf
  set isf&vim
  let fn = expand("<cfile>")
  let &isf=isf_save
  if isdirectory(fn) || filereadable(fn)
    if(&mod == 1)
      silent! normal gf
    else
      silent! normal go
    endif
    return
  endif

  let v:errmsg=""
  silent! execute("tag ". expand("<cword>"))
  if(v:errmsg == "")
    return
  endif

  if getline('.')=~'^\s*#*include'
    if(&mod == 1)
      silent! normal gf
    else
      silent! normal go
    endif
    return
  endif

  silent! normal za
  " if foldclosed('.') != -1 || getline('.')=~'{\|}' || search('{', 'nb') > 0
  "   silent! normal za
  "   return
  " endif

endf

func! ExecuteIt()
  let fn = Foo_GetFileName()
  let fn = fnamemodify(fn, ":r")
  let fn = fn . '.exe'
  if filereadable(fn)
    exec 'silent !start rundll32 url.dll,FileProtocolHandler "'
	  \ . escape(fn, '%#!') . '"'
  endif
endf

func! CopyIt(fileName, dest)
  if (g:UseWinCopy == 1)
    let cmd = 'copy ' .
	  \'"' . WinPath(a:fileName) . '"'.
	  \" " .
	  \'"' . WinPath(a:dest) . '"'
    let @_=system(cmd)
  else
    if a:dest =~ '^\\\\'
      let cmd = 'cp -r ' .
	    \'"' . a:fileName . '"'.
	    \" " . a:dest
    else
      let cmd = 'cp -r ' .
	    \'"' . UnixPath(a:fileName) . '"'.
	    \' '.
	    \'"' . UnixPath(a:dest) . '"'
    endif

    if has("win32")
      let cmd ='!start ' . cmd
    else
      let cmd ='!' . cmd
    endif
    silent execute cmd
  endif
endf

if !exists("g:UseWinMove")
  let g:UseWinMove=1
endif

func! MoveIt(fileName, dest)
  let fileName = a:fileName
  if(isdirectory(fileName))
    let fileName = substitute(a:fileName, '[\/]$', '', '')
  endif
  if (g:UseWinMove == 1)
    let cmd = 'move ' .
	  \'"' . WinPath(fileName) . '"'.
	  \" " .
	  \'"' . WinPath(a:dest) . '"'
    let @_=system(cmd)
    if (v:shell_error)
      call Warning_Msg(v:errmsg)
    endif
    return v:shell_error
  else
    let cmd = 'mv -i ' .
	  \'"' . fileName . '"'.
	  \" " .
	  \'"' . a:dest . '"'

    if has("win32")
      let cmd ='!start ' . cmd
    else
      let cmd ='!' . cmd
    endif
    silent execute cmd

    let i = 0
    while i<2 && (isdirectory(fileName)||filereadable(fileName))
      let i = i + 1
      silent execute 'sleep 100m'
    endwhile
  endif
  return 0
endf

let s:decodefile=expand("<sfile>:h")."/utils/decodeURI.wsf"
func! DecodeURI(url)
  let url = system("cscript //Nologo " . s:decodefile . " /url:" . a:url)
  return substitute(url, '\n', '', '')
endf

nnoremap 'd :call ExecuteIt()<cr>

nnoremap <2-leftMouse> :call MyDoubleClick()<cr>
nnoremap <cr> :call MyDoubleClick()<cr>

nnoremap <M-b> :call Foo_GotoParentdir()<cr>
nnoremap <M-[> :call GotoParentdirOrHead()<cr>
" nnoremap <RightMouse> :call Foo_GotoParentdir()<cr>
nnoremap <RightMouse> :call GotoParentdirOrBack()<cr>
" map <M-[> <C-t>
func! OpenByOtherPrg()
  if &ft == "nerdtree"
    if exists("b:curdir")
      let dir = b:curdir
    else
      let dir = GetDirectoryName()
    endif
    " let cmd = 'D:\skill\Apps\totalcmd\TOTALCMD.EXE /O /T ' . '"' . dir . '"'
    let cmd = 'D:\skill\Apps\totalcmd\TOTALCMD.EXE /O ' . '"' . dir . '"'
  else
    let cmd = 'D:\skill\Apps\insight3\Insight3.exe -i +' . line(".") . " " . '"'. Foo_GetFileName(). '"' 
  endif
  execute('silent !start '.cmd)
endf
noremap <M-/> :call OpenByOtherPrg()<cr>

func! GetSimilarFile(step)
  let a = expand("%:t")
  if a
    let p='\d*\([^0-9]*$\)\@='
    let b = matchstr(a, p) + a:step
    let c =  substitute(a, p, b, '')
    if filereadable(c)
      return c
    endif
  endif
endf

func! DiffSimilarFile(step)
  let a = GetSimilarFile(a:step)
  if a
    execute("only")
    execute("vert diffsplit " . a)
    execute("normal \<C-W>h")
  endif
endf

map <C-PageUp> :<C-U>call DiffSimilarFile(-1 * v:count1)<cr>
map <C-PageDown> :<C-U>call DiffSimilarFile(v:count1)<cr>
" vim: set fdm=marker:
