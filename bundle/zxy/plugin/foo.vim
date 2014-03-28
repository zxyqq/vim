if exists("loaded_Foo")
  finish
endif

let loaded_Foo=1

if !exists("loaded_commonfunc")
  runtime plugin/commonfunc.vim
endif

if !exists("loaded_taglist")
  runtime plugin/taglist.vim
else
  if loaded_taglist != 'available'
    runtime plugin/taglist.vim
  endif
endif

let g:env="$HOME;$VIM;$JAVA_HOME"

if !exists("g:Deb_1_Cyg_0")
  let g:Deb_1_Cyg_0 = 1
  let g:Deb_Drv = 'A'
  let g:Deb_Root = ''
endif

if !exists("g:GCCCFLAGS")
  let g:GCCCFLAGS="-Wall"
endif

if !exists("g:cygwin_home")
  let g:cygwin_home='d:/PortableApps/cygwin'
endif

if !exists("g:Foo_search_dir")
  let g:Foo_search_dir = ''
endif

if !exists("g:qflastcmd")
  let g:qflastcmd = ""
endif

if !exists("g:makeqfdir")
  let g:makeqfdir = ""
endif

if !exists("g:grepqfdir")
  let g:grepqfdir = ""
endif

if !exists("g:Foo_LastWinDir")
  let g:Foo_LastWinDir=''
endif

if has("win32")
  let s:escfilename = '%#*?'
else
  let s:escfilename = ' %#*?'
endif

let s:specialmarks='!'

if !exists("g:Java_Classpath")
  let g:Java_Classpath= '.;
	\F:\skill\programming\java\ant\release\src\apache-ant-1.8.1\src\main'
endif


if !exists("g:INCLUDE_DIR")
  let g:INCLUDE_DIR='
	\.;
	\c:\devcpp\include'
endif

if !exists("g:DirCreateSplit")
  let g:DirCreateSplit='e'
endif

if !exists("g:FileCreateSplit")
  let g:FileCreateSplit='sp'
endif

if !exists("g:Foo_Total_Win_Num")
  let g:Foo_Total_Win_Num=12
endif

if !exists("g:Foo_LastWinName")
  let g:Foo_LastWinName=''
endif

if !exists("g:lastClosedName")
  let g:lastClosedName=''
endif

if !exists("g:NewFileStartIns")
  let g:NewFileStartIns = 0
endif

function! s:Foo_ExplFileHandlerWin32(fn)
  let newfn=UnixPath(a:fn)
  silent exec '!start rundll32 url.dll,FileProtocolHandler "'
	\ . escape(newfn, '%#') . '"'
endfunction

function! s:Foo_ExecuteEntry(path)
  if a:path==""
    let thisline=escape(getline("."),'%#!*')
    let thisline=substitute(thisline, '\s\{0,}\(.*\)', '\1', '')
    let answer = input("give your text: ",thisline)
    if answer!=''
      call <SID>Foo_ExplFileHandlerWin32(answer)
    endif
  else
    call <SID>Foo_ExplFileHandlerWin32(a:path)
  endif
  return
endfunction

function! s:Foo_OpenCurWindow()
  call <SID>Foo_ExplFileHandlerWin32(GetDirectoryName())
endfunction

function! s:Foo_DelFile()
  if exists("b:maxFileLen")
    let l=getline(".")
    if l=='../' || l=='./'
      call Warning_Msg("Sorry: cannot remove `.' or `..'")
      return
    endif
  endif

  let fn=Foo_GetFileName()
  let curwinnr=winnr()
  let isdir=0
  if isdirectory(expand("%:p"))
    let isdir=1
  else
    let pardir=fnamemodify(UnixPath(expand("%:p")), ":h")
  endif
  echohl WarningMsg
  let sure=input("Delete ".fn." (y/n/)? ")
  echohl None
  if sure!="y"
    return
  endif

  if has("win32")
    let success = s:Foo_RemoveAttr(fn)
    if success!=0
      call Warning_Msg("can not remove readonly attribute ".fn)
      return
    endif
  endif

  let cmd = 'rm -r ' . '"' . fn . '"'
  let @_=system(cmd)
  if (v:shell_error)
    call Warning_Msg("can not delete file ".fn)
    return
  endif

  if isdir==1
    setlocal noreadonly modifiable
    d _
    setlocal readonly nomodifiable
  else
    let winnum=WindowExistNo(pardir)
    if(winnum!=-1)&&(winnum!=curwinnr)
      silent execute("close")
      if winnum>curwinnr
	let winnum=winnum-1
      endif
      silent execute(winnum . "wincmd w")
    else
      silent execute('edit '.pardir)
    endif
  endif
  return
endfunction

function! s:Foo_RemoveAttr(fn)
  if isdirectory(a:fn)
    let cmd = 'attrib -R ' . a:fn . '\* ' . '/S /D'
  else
    let cmd = 'attrib -R ' . a:fn
  endif
  let @_ = system(cmd)
  return v:shell_error
endfunction

function! s:Foo_MoveFile()
  let origwinnum = winnr()
  let isdir=isdirectory(expand("%:p"))

  let fn = Foo_GetFileName()
  let dest=input('mv '. fn. ' ')
  let dest=substitute(dest, '\s\+$', '','')
  if dest == ""
    return
  endif

  "if isdirectory(fn) && !isdirectory(dest)
  if isdirectory(fn) && filereadable(dest)
    call Warning_Msg("sorry, cannot move directory to file")
    return
  endif

  call MoveIt(fn, dest)

  " if isdirectory(fn)||isdirectory(dest)
  "   let destdir=dest
  " else
  "   let destdir = GetDirectoryName(dest)
  " endif
  "
  " let destdir = escape(destdir, s:escfilename)
  " let winnum=WindowExistNo(destdir)
  " if (winnum!=-1) && (origwinnum != winnum)
  "   silent execute(winnum . "wincmd w")
  "   silent execute('Explore')
  " else
  "   silent execute('sp '. Path(destdir))
  " endif
  " wincmd p
  "
  " if (isdir)
  "   execute('Explore')
  " else
  "   execute('e ' .GetDirectoryName())
  " endif
  " return
endfunction

function! s:Foo_CopyFile()
  let fn = Foo_GetFileName()
  let dest = input('copy ' . fn . ' ')
  let filetofile = 0

  if dest == ""
    return
  endif

  "if isdirectory(fn)
    "call Warning_Msg("only support file!")
    "return
  "endif

  if !isdirectory(dest)
    let filetofile = 1
    let destdir = GetDirectoryName(dest)
  else
    let destdir = dest
  endif

  let destdir = escape(destdir, s:escfilename)

  if(filetofile==1)
    let filedir =  fnamemodify(fn, ":h")
    if filedir == AddLastSlash(destdir)
      let target = dest
    else
      let filetail = fnamemodify(dest,":p:t")
      let target = TrimLastSlash(destdir). g:FS . filetail
    endif
    if (target==fn)
      call Warning_Msg("copy to the same file!")
      return
    endif
  else
    let filetail = fnamemodify(fn,":p:t")
    let target = TrimLastSlash(destdir). g:FS . filetail
  endif

  if(filereadable(target))
    call Warning_Msg("already exist!")
    let ask = input("overwrite existing file: [".target."] (y/n)?", "n")
    if ask == 'n'
      call Warning_Msg("ok, give up overwrite: [". target. "]!")
      return
    endif
  endif

  call CopyIt(fn, dest)

  if (v:shell_error)
    call Warning_Msg(v:errmsg)
    return
  endif

  if filetofile == 1
    silent execute("sp " . dest)
    return
  endif

  let destdir = escape(destdir, s:escfilename)
  let winnum = WindowExistNo(destdir)
  if winnum != -1
    silent execute(winnum . 'wincmd w')
    silent execute('Explore')
  else
    silent execute("sp " . destdir)
  endif
  return
endfunction

function! s:Foo_Findfile()
  call GetDirectoryName()
  echohl WarningMsg
  let sfname = input('search file: ')
  echohl None
  if sfname == ""
    return
  endif

  let sfname=escape(sfname,s:escfilename)
  call GetDirectoryName()
  if b:curdir!=""
    echohl WarningMsg
    let answer=input("need case insensitive: ", "N")
    echohl None
    if answer=='N'
      let cmd = 'find ' ."'". b:curdir. "'".  ' -name '
    else
      let cmd = 'find ' ."'". b:curdir. "'".  ' -iname '
    endif
    let isf_save=&isf
    set isf&vim
    let &makeprg = cmd
    set efm&vim
    silent execute('make '.sfname)
    silent execute('botright cope')
    let l=getline(".")
  else
    let isf_save=&isf
    let l=''
  endif
  if l==''
    silent execute('cclose')
    if !exists("g:Foo_search_dir")||g:Foo_search_dir==""
      call Warning_Msg("Sorry, not found [".sfname."]")
      return
    endif
    let searchdir=g:Foo_search_dir
    while(searchdir!="")
      let start=0
      let pos=GetPatternPos(searchdir, ';')
      let len= pos - start
      let dir=strpart(searchdir, start, len)
      let searchdir=strpart(searchdir, pos+1)
      let cmd = 'find ' ."'".dir. "'".  ' -iname '
      let &makeprg=cmd
      silent execute('make '. sfname)
      silent execute('botright cope')
      let l=getline(".")
      if l!=''
	break
      endif
      silent execute('cclose')
    endwhile
  endif
  if l==''
    call Warning_Msg("Sorry, not found [".sfname."]")
  endif
  let &isf=isf_save
endfunction

function! s:Foo_CreateDirFile(action)
  call GetDirectoryName()
  let isdir = isdirectory(expand("%:p"))
  echohl WarningMsg
  let things = input(a:action . ' ' . b:curdir . g:FS)
  echohl None
  if things == ''
    return
  endif

  if has("win32") && things=~? '^\a:\\'
    call Warning_Msg("sorry, only support relative path")
    return
  endif

  let targetDir    = b:curdir . g:FS
  let totalcount=0
  let createsuccess=0
  let createfail=0
  let createskip=0
  let morethanone=0
  let skipthings=""
  let failthings=""
  while(things!="")
    let totalcount=totalcount+1
    let start=0
    let pos=GetPatternPos(things, ",")
    let len=pos-start
    let single=strpart(things, start, len)
    let things=strpart(things,pos+1)
    while single[strlen(single)-1] == "\\" && (things!="")
      let single = strpart(single, 0, strlen(single)-1) . ","
      let start=0
      let pos=GetPatternPos(things, ",")
      let len=pos-start
      let single=single . strpart(things, start, len)
      let things=strpart(things,pos+1)
    endwhile

    if (things!="")
      let morethanone=1
    endif

    let target = targetDir . single

    let targetEsc = escape(target, s:escfilename)

    if(isdirectory(target)||filereadable(target))
      if morethanone==0
	call Warning_Msg(single." already exist!")
	let winnum=WindowExistNo(target)
	if(winnum!=-1)
	  silent execute(winnum . "wincmd w")
	  wincmd p
	else
	  silent execute('sp ' .targetEsc)
	  wincmd p
	endif
	return
      else
	let createskip=createskip+1
	let skipthings = skipthings . single .";"
      endif

    else

      if target =~? '^\/\/'
	let target = substitute(target, '\/', '\\', 'g')
      endif

      let cmd = a:action .  ' "' .target. '"'

      let @_=system(cmd)
      if (v:shell_error)
	if morethanone==0
	  call Warning_Msg(single.' fail!')
	  return
	else
	  let createfail=createfail+1
	  let failthings=failthings.single.";"
	endif
      else
	let createsuccess=createsuccess+1
      endif
    endif
  endwhile

  if (totalcount==1)
    let i = 0
    while i<10 && !(isdirectory(targetEsc)||filereadable(targetEsc))
      let i = i + 1
      silent execute 'sleep 100m'
    endwhile

    let act=(a:action=="mkdir")?
	  \g:DirCreateSplit : g:FileCreateSplit
    if &mod==1
      let act='sp'
    endif

    silent! execute(act. ' ' .targetEsc)

    if(isdir)&&(act=='sp')
      wincmd p
      setlocal noreadonly modifiable
      silent e!
      setlocal nomodified
      setlocal readonly nomodifiable
      wincmd p
    endif

    if a:action=="touch" && g:NewFileStartIns
      if &modifiable==1
	exe "startinsert"
      else
	call Warning_Msg("failed!")
      endif

    endif

    if a:action=="mkdir"
      let @r=WinPath(target)
      let g:Foo_LastWinDir=target
    else
      let @r=WinPath(targetDir)
    endif

  else
    let word=(a:action=="touch")?"files" : "directories"
    echohl WarningMsg
    echo "[Total]: ". totalcount. " ".word
    echo "[success]: ".createsuccess. " ".word
    echo "[fail]: ".createfail." ".word.": ".failthings
    echo "[skip]: ".createskip." ".word.": ".skipthings
  endif
  return
endfunction

function! Foo_GetFileName()
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
    return path.drive . g:FS . join(path.pathSegments, g:FS) 
  endif

  let filepath = expand("%:p")
  let filepath = escape(filepath, s:escfilename)
  if filepath == ""
    return filepath
  endif

  if !exists("b:maxFileLen")
    return filepath
  endif

  let fn = getline(".")
  if fn =~? '^\.\+\/$' || fn =~? '^"'
    return TrimLastSlash(filepath)
  endif

  let fn = substitute(strpart(getline("."), 0, b:maxFileLen), '\s\+$', '', '')
  let fn = escape(fn, s:escfilename)
  let fn = Path(fn)

  let filepath = GetDirectoryName() . g:FS . fn
  return TrimLastSlash(filepath)
endfunction

function! s:Foo_Check_StartOnly()
  let lastwinnr = winnr()
  if winnr('$') == 1 && GetDirectoryName() == '' && &mod == 0
    return 1
  endif
  return 0
endfunction

function! Foo_Test(path)
  if winnr('$') < g:Foo_Total_Win_Num
    let action='sp '
  else
    let action='e '
  endif
  let cmd=action.a:path
  return cmd
endfunction

function! GoToWindow(title, cmd)
  let winnum = bufwinnr(a:title)
  if (winnum != -1)
    let cmd = winnum. "wincmd w"
    silent! execute cmd
  else
    silent! execute a:cmd
  endif
endf

function! Foo_Open_Only_One(fn)
  let action = ((s:Foo_Check_StartOnly()) ? "e " : "sp " )

  if a:fn =~? '^[a-z]:'
      let fullfn = a:fn
  else
      let fullfn = pathogen#rtpfindfile(a:fn,1)
  endif

  let winnum = WindowExistNo(fullfn)
  if winnum != -1
    silent execute(winnum . "wincmd w")
    silent execute(bufnr(fullfn). 'buffer')
  else
    silent execute(action . fullfn)
  endif
  return
endfunction

function! s:Foo_Record_Last_WinInfo()
  let g:Foo_LastWinName=expand("%:p")
  let g:Foo_LastWinDir=GetDirectoryName().g:FS
  if g:Foo_LastWinDir =~? '^\/\/'
    let g:Foo_LastWinDir = substitute(g:Foo_LastWinDir, '\/', '\\', 'g')
  endif
endfunction

func! s:Foo_UnCloseLastWindow()
  if g:lastClosedName == ""
	\|| g:lastClosedName == expand("%:p")
    if  g:Foo_LastWinName != ""
      let g:lastClosedName = g:Foo_LastWinName
    else
      call Warning_Msg("sorry, no previous windows")
      return
    endif
  endif

  let winnum = WindowExistNo(g:lastClosedName)

  if winnum == -1 || winnum == winnr()
    silent execute('new ' . g:lastClosedName)
  else
    silent execute(winnum . 'wincmd w')
  endif
endf

func! s:Foo_CopyName(do,...)
  if expand("%:p:t")=~?"ls-1R"
    echohl WarningMsg
    let style = input("Normal(n) or ls(l): ", "l")
    echohl None
  else
    let style = ""
  endif

  if style == "l"
    let content = s:Foo_Checkls()
    if a:do=="dir"
      let content = GetDirectoryName(content)
    endif

  elseif a:do=="full"
    let content = Foo_GetFileName()
    if isdirectory(content)
      let content=content.g:FS
    endif
  elseif a:do=="dir"
    let content = GetDirectoryName().g:FS
  else
    return
  endif

  if(a:0 == 0)
    if has("win32")
      let content=substitute(content,'/','\\','g')
    else
      let content=substitute(content,'\\','\/','g')
    endif

  elseif(a:0 == 1 && a:1 == 'unix')
    let content=substitute(content,'\\','\/','g')
    let deb_pat="^".g:Deb_Drv.":"
    if content =~? '^[c|d|e]:'
      let content=substitute(content, '^\(\a\):','/media/\l\1','g')
    elseif content =~? deb_pat
      let content=substitute(content, deb_pat, g:Deb_Root, '')
      let content=substitute(content,'\\','\/','g')
    endif
    let content=escape(content, " ()&'")

  elseif(a:0 == 1 && a:1 == 'cygwin')
    let content=substitute(content,'\\','\/','g')
    let content=substitute(content,'\/$','','g')
    let content=substitute(content,'\([a-zA-Z]\):','/\l\1','g')
    let content=escape(content,' ()')

  else
    let content=substitute(content,'\\','\/','g')
  endif

  let @*=content
  let @r=content
  return
endfunction

func! s:Foo_Grepstring()
  let isf_save=&isf
  set isf&vim

  let do=input(&grepprg)
  if do==""
    return
  endif
  let do = escape(do, '#')
  let g:grepqfdir=GetDirectoryName()
  silent execute("grep ".do)
  silent execute('botright cope')
  let g:qflastcmd = "grep"
  let &isf=isf_save
endf

function! s:StripHeader(f)
  let ret = a:f

  if &ft=="qf"
    let ret=substitute(ret, '^||\s', '', '')
  endif

  if has("win32")
    let pat1='\a:[\\\/][^"]*'
    let pat2='[^:"\t ]\?[\.]\{1,2}\/[^"].*'
    if a:f =~? pat1
      let ret = matchstr(a:f, pat1)
    elseif a:f =~? pat2
      let ret = matchstr(a:f, pat2)
    endif
  else
    let pat ='[^:"\t ]\?[\.]\{1,2}\/[^"].*'
    if a:f =~? pat
      let ret = matchstr(a:f, pat)
    endif
  endif

  return ret
endf

function! s:GetAbsPath(fn)
  if IsAbsPath(a:fn)
    return a:fn
  endif

  let ret = a:fn

  if &ft=="qf"
    if (g:qflastcmd == "make" && g:makeqfdir!="")
      return g:makeqfdir.g:FS.a:fn
    elseif (g:qflastcmd == "grep" && g:grepqfdir != "")
      let fn  = substitute(a:fn, '^[\/]', '', '')
      let candidate = g:grepqfdir[0]. ":" . g:FS. fn
      let fn2 = s:StripFileName(candidate)
      if !(filereadable(fn2)||isdirectory(fn2))
	let candidate = g:grepqfdir.g:FS.fn
      endif
      return candidate
    endif
  elseif has("win32")
    let ret = s:ModifyCygwinPath(ret)
  endif

  if IsAbsPath(ret)
    return ret
  endif
  return GetDirectoryName().g:FS.ret
endf

function! s:ModifyCygwinPath(fn)
  let ret = UnixPath(a:fn)

  if ret =~? '^\/'
    let pat1 = '^\/cygdrive/\(\a\)/\(.*\)'
    let pat2 = '^\/usr\/\(bin\|lib\)'

    if(ret =~? pat1)
      let ret = substitute(ret, pat1, '\1:/\2', '')
    else
      if (g:Deb_1_Cyg_0 == 1)
	let ret = g:Deb_Drv . ":" . ret
      else
	if(ret =~? pat2)
	  let ret = substitute(ret,pat2,g:cygwin_home.'/'.'\1','')
	else
	  let ret = g:cygwin_home.ret
	endif
      endif
    endif
  else
    return Path(a:fn)
  endif

  if (g:Deb_1_Cyg_0 == 0)
    if !filereadable(ret) && !isdirectory(ret)
      let suffix='.exe'
      if !filereadable(ret.suffix) && !isdirectory(ret.suffix)
	let suffix='.lnk'
      endif
      let ret=ret.suffix
    endif
  endif

  return Path(ret)

endfunction

function! s:ExpandEnvironmentVar(var)
  let retvar=substitute(a:var, '%\([^%]*\)%', '$\1', 'g')
  let env=g:env
  while(env!="")
    let v=""
    let pos=GetPatternPos(env, ";")
    let k=strpart(env, 0, pos)
    let env=strpart(env,pos+1)
    let v=expand(k)
    if(v!="")
      let retvar=substitute(retvar, k, v, '')
    endif
  endw
  return retvar
endf

function! s:CheckCursorFile()
  let fn=expand('<cfile>')

  if &ft == "javascript"
    let ln = getline(".")
    if ln =~ "require('[^']*')"
      let pat = "\\(require('\\)\\@<=[^']*\\(')\\)\\@="
      let fn = matchstr(ln, pat). '.js'
      if IsAbsPath(fn)
	return fn
      else
	return expand("%:p:h").g:FS.fn
      endif
    endif
  endif

  if fn == "||" && &ft == "qf"
    normal w
    let fn=expand('<cfile>')
  endif

  let fn=substitute(fn, '^\/media\/\([de]\)\/','\1:/','g')
  let fn=StripEscape(fn, "[ ()&'']")

  let pat = '[a-z]*:\([^0-9\/]\)\@='
  let fn = substitute(fn, pat, '', '')
  let pat = '^.*\([a-z]:\\\)\@='
  let fn = substitute(fn, pat, '', '')

  let fn=s:ExpandEnvironmentVar(fn)
  let fn = s:StripHeader(fn)
  let fn = s:GetAbsPath(fn)

  let stripedfn=s:StripFileName(fn)
  if isdirectory(stripedfn)||filereadable(stripedfn)
    let fileln=s:StripFileLn(fn)
    if fileln!=""
      return fn
    else
      return TrimLastSlash(stripedfn)
    endif
  else
    let suffix='.exe'
    let stripedfn=stripedfn . suffix
    if isdirectory(stripedfn)||filereadable(stripedfn)
      let fileln=s:StripFileLn(fn)
      if fileln!=""
	return stripedfn.":".fileln
      else
	return TrimLastSlash(stripedfn)
      endif
    endif
  endif
  return ""
endfunction

func! s:StripFileName(path)
  if has("win32")
    let pat='\(\a:[\\\/][^:|]*\)[:|]\?.*'
  else
    let pat='\(\/.*\)[:|]\?.*'
  endif
  return substitute(a:path, pat, '\1', '')
endf

func! s:StripFileLn(path)
  let pos1=stridx(a:path, ":")
  if (pos1 == 1) && has("win32")
    let pos1=stridx(strpart(a:path,2), ":")
  endif

  if pos1== -1
    let pos2=stridx(a:path, "|")
    if (pos2==-1)
      return ""
    endif
  endif

  if has("win32")
    let pat='\(^\a:[^:|]*\)[:|]\(\d\{1,}\).*'
  else
    let pat='\(\/\a.*\)[:|]\(\d\{1,}\).*'
  endif
  return substitute(a:path, pat, '\2', '')
endf

func! s:IsIncludeLine()
  let pat1='^\s\{0,}[@%#]\s\{0,}include\s\{0,}"[^"]\{1,}"'
  let pat2='^\s\{0,}[@%#]\s\{0,}include\s\{0,}<[^"]\{1,}>'
  if getline(".") =~? pat1
    return 1
  elseif getline(".") =~? pat2
    return 2
  endif
  return 0
endf

func! s:IsLineStartWith(p)
  let pat='^\s\{0,}'.a:p.'\s\{0,}'
  if getline(".") =~? pat
    return 1
  endif
  return 0
endf

func! s:Python_Header(p)
  let l=getline(".")
  let pat='^\s\{0,}'.a:p.'\s\{0,}'
  let gofile=substitute(l,pat,'','')
  let gofile=matchstr(gofile,'[a-zA-Z_0-9]\+')
  let gofile=gofile.'.py'

  let gotodir=g:PYTHONPATH
  while(gotodir!="")
    let start=0
    let pos=GetPatternPos(gotodir, ";")
    let len=pos-start
    let dir=strpart(gotodir, start, len)
    let gotodir=strpart(gotodir,pos+1)
    let dir = substitute(dir, '[\/]\{0,}$', g:FS, '')
    let fn=dir.gofile
    if isdirectory(fn)||filereadable(fn)
      return fn
    endif
  endwhile
endf

func! s:Java_Header(p)
  let l=getline(".")
  let pat='^\s\{0,}'.a:p. '\( static\)*'.'\s\{0,}'
  let gofile=substitute(l,pat,'','')
  let gofile=matchstr(gofile, '[.a-zA-Z_0-9]\+[a-zA-Z_0-9]\(\.\*\)*')

  let pat='\.\*'
  let gofile=substitute(gofile,pat,'','')

  let pat='\.'
  let gofile=substitute(gofile,pat,g:FS,'g')

  let gotodir=g:Java_Classpath
  while(gotodir!="")
    let start=0
    let pos=GetPatternPos(gotodir, ";")
    let len=pos-start
    let dir=strpart(gotodir, start, len)
    let gotodir=strpart(gotodir,pos+1)
    let dir = substitute(dir, '[\/]\{0,}$', g:FS, '')
    let fn=dir.gofile
    if isdirectory(fn)||filereadable(fn)
      return fn
    elseif (a:p=="import")
      let fn=dir.gofile.".java"
      if isdirectory(fn)||filereadable(fn)
	return fn
      endif
    endif
  endwhile

endf

func! s:C_Header_Include(type)
  if a:type == 0
    return
  endif

  let l=getline(".")

  if a:type == 1
    let leftpos=stridx(l, '"')
    let part=strpart(l, leftpos+1)
    let rightpos=stridx(part, '"')
    let gofile=strpart(part, 0, rightpos)
    if IsAbsPath(gofile)
      return gofile
    endif

    let curdirFS = GetDirectoryName().g:FS
    let fn = curdirFS . gofile
    if filereadable(fn)
      return fn
    elseif filereadable(curdirFS . 'makefile')
      let kw='^[ ]*[^#][^#]*-I'
      let cmd = "sed -n /" . '"' . kw .  "/p" . '"' .' makefile'
      let line = system(cmd)
      let line = substitute(line, '[\n]', '', 'g')
      let pat = '-I[^ -]*'

      while(line =~? pat)
	let dir = strpart(matchstr(line, pat), 2)
	let dir = substitute(dir, '[\/]$', '', '')
	let fn = curdirFS . dir. g:FS . gofile
	if filereadable(fn)
	  return fn
	else
	  let line = substitute(line ,pat , '', '')
	endif
      endw
    endif

  elseif a:type == 2
    let leftpos=stridx(l, '<')
    let part=strpart(l, leftpos+1)
    let rightpos=stridx(part, '>')
    let gofile=strpart(part, 0, rightpos)
    if IsAbsPath(gofile)
      return gofile
    end
    let gotodir=g:INCLUDE_DIR
    while(gotodir!="")
      let start=0
      let pos=GetPatternPos(gotodir, ";")
      let len=pos-start
      let dir=strpart(gotodir, start, len)
      let gotodir=strpart(gotodir,pos+1)
      let dir = substitute(dir, '[\/]\{0,}$', g:FS, '')
      let fn=dir.gofile
      if isdirectory(fn)||filereadable(fn)
	return fn
      endif
    endwhile
  endif
endf

function! s:MakeFile_Inc_Path()
  let old_isf = &isf
  set isf&vim
  set isf-=32
  let fn=getline(".")
  let &isf = old_isf
  let pat='[=]\{0,1}-I'
  if fn =~? pat
    let fn = substitute(fn, '-I', '', '')
  else
    let pat='^\s\{0,}include\s\{1,}'
    if fn =~? pat
      let fn = matchstr(fn, '\('.pat.'\)'. '\@<='. '\([^ ]\)*')
    else
      return
    endif
  endif

  if IsAbsPath(fn)
    return fn
  endif
  return GetDirectoryName().g:FS.fn
endf

function! s:Foo_Checkls()
  let dirpattern = ':$'
  let ln = line(".")
  while ln > 0
    if getline(ln) =~? dirpattern
      break
    endif
    let ln = ln - 1
  endwhile

  let pardir = substitute(getline(ln), ':$', '', '')

  if !IsAbsPath(pardir)
    let pardir=expand("%:p:h").g:FS.pardir
  endif

  if ln == line(".")
    return pardir
  endif

  return pardir. g:FS. substitute(getline("."), ':$', '', '')
endf

function! s:SubCheckit()
  set isfname-=32
  let yes = s:CheckCursorFile()
  if yes!=""
    return yes
  else
    set isfname+=32
    let yes = s:CheckCursorFile()
    if yes!=""
      return yes
    endif
  endif
endf

func! GetFileNameSmart()
  if expand("%:p:t")=~?"ls-1R"
    return s:Foo_Checkls()
  endif

  if (&ft=="c"||&ft=="cpp")
    let type=s:IsIncludeLine()
    if(type)
      return s:C_Header_Include(type)
    endif
  endif

  if (&ft=="php")
    if getline(".") =~? '^\s*include'
      let l=getline(".")
      let leftpos=stridx(l, "'")
      let part=strpart(l, leftpos+1)
      let rightpos=stridx(part, "'")
      let gofile=strpart(part, 0, rightpos)
      return gofile
    endif
  endif

  let isf_save = &isf
  set isf&vim
  set isfname-==
  if(&ft=="qf")
    set isf+=124
  endif

  set isf+=:
  set isf+=&
  set isf-=;

  set isfname-=(,)
  set isfname-=39
  let yes = s:SubCheckit()
  if yes != ""
    let &isf = isf_save
    return yes
  endif

  set isfname-=(,)
  set isfname+=39
  let yes = s:SubCheckit()
  if yes != ""
    let &isf = isf_save
    return yes
  endif

  set isfname+=(,)
  set isfname-=39
  let yes = s:SubCheckit()
  if yes != ""
    let &isf = isf_save
    return yes
  endif

  set isfname+=(,)
  set isfname+=39
  let yes = s:SubCheckit()
  if yes != ""
    let &isf = isf_save
    return yes
  endif

endfunction

function! Foo_GotoFile(action)
  let old_isf=&isf
  let findsuccess=0

  if &ft == "c" || &ft == "cpp"
    let l = getline(".")
    let pat = '^#line \(\d\+\) "\([^"]\+\)"'
    if l =~? pat
      let fn = substitute(l, pat, '\2', '')
      let fileln = substitute(l, pat, '\1', '')
      let findsuccess=1
    endif
  endif
  if findsuccess==0
    let cursorfn=GetFileNameSmart()
    if cursorfn!=""
      let fn=s:StripFileName(cursorfn)
      let fileln=s:StripFileLn(cursorfn)
    else
      call Warning_Msg("Sorry, no file under cursor!")
      let &isf=old_isf
      return
    endif
  endif

  if(a:action=="d")
    let pardir =  fnamemodify(fn, ":h")
    let winnum=WindowExistNo(pardir)

  else
    if has("win32")
      let extension = fnamemodify(fn, ":t:e")
      let extension = substitute(extension, " ", "", "g")
      if (extension!="")&&
	    \match(g:Execute_Extension, ','.extension.',')!=-1
	call <SID>Foo_ExplFileHandlerWin32(escape(fn,'!'))
	let &isf=old_isf
	return
      endif
    endif
    let winnum=WindowExistNo(fn)
  endif

  if(winnum != -1)
    silent execute(winnum . "wincmd w")
  else
    let v:errmsg=""
    if(a:action=="d")
      let cmd="sfind ".pardir
    elseif(a:action=="o")
      let cmd="find ".fn
    else
      let cmd="sfind ".fn
    endif
    silent! execute(cmd)
    if(v:errmsg!="")
      call Warning_Msg("sorry, not find")
      let &isf=old_isf
      return
    endif
  endif
  if exists("fileln")&&(fileln=~?'^\d\{1,}$')
    execute(fileln)
  endif
  let &isf=old_isf
endf

function! s:Foo_Max_last_two_window()
  silent execute "normal \<C-W>_"
  let lastwinh=winheight(0)
  wincmd p
  let curwinh=winheight(0)
  let h=(curwinh+lastwinh)/2
  silent execute("resize ".h)
  wincmd p
endf

func! Foo_GetParentDir()
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
    if path.isDirectory && node.isOpen
      return path.drive . g:FS . join(path.pathSegments, g:FS) 
    else
      return path.drive . g:FS . join(path.pathSegments[0:-2], g:FS) 
    endif
  else
    return GetDirectoryName()
  endif
endf

func! Foo_Opendir(do)
  let path = Foo_GetParentDir()
  if &ssl==1
    let cmd = a:do . " " . path . '/*'
  else
    let cmd = a:do . " " . path . g:FS . '*'
  endif
  " redraw!
  return cmd
endf

function! s:RefreshIfNotMod()
  if &mod == 0
    execute("e!")
  else
    call Warning_Msg("Sorry, save current file first!")
  endif
endf

function! GetCursorFileName()
  if exists("b:maxFileLen")
    let ret = substitute(strpart(getline("."),0,b:maxFileLen), '[\/\\]\{0,}\s\=$','','')
  else
    let ret = GetFileNameSmart()
    "let ret = Foo_GetFileName()
    if ret == ""
      let ret =  getline(".")
    endif
  endif
  if has("win32")
    return WinPath(escape(ret,s:specialmarks))
  endif
  return escape(ret,s:specialmarks)
endfunction

function! GoToWindow(title, cmd, ...)
  let winnum = bufwinnr(a:title)
  if (winnum != -1)
    let cmd = winnum. "wincmd w"
    silent! execute cmd
  else
    silent! execute a:cmd
  endif
endf

function! GoToWindowTaglist()
  call GobalTlist_Refresh()
  call GoToWindow(g:TagList_title, "TlistOpen")
endf

function! GoToWindowProject()
  call GoToWindow("~/.vimprojects", "Project")
endf

fun! ToggleWidth(title,width)
  let lzsave=&lz
  let winnum = bufwinnr(a:title)
  if (winnum == -1)
    return
  endif
  let curwinnr = winnr()
  if curwinnr != winnum
    let cmd = winnum. "wincmd w"
    silent! execute cmd
  endif
  let cmd = 'vertical resize ' . a:width
  silent! wincmd cmd
  if curwinnr != winnum
    silent! wincmd p
  endif
  let &lz=lzsave
endf

func! EqualWindow()
  silent! execute "normal \<C-W>="

  if (exists("g:TagList_title"))
    call ToggleWidth(g:TagList_title, g:Tlist_WinWidth)
  endif

  if (exists("g:proj_window_width"))
    call ToggleWidth("~/.vimprojects", g:proj_window_width)
  endif

endf

nnoremap <M-t> :call GoToWindowTaglist()<cr>
nnoremap <M-=> :call EqualWindow()<cr>

cmap <M-z> <C-R>=substitute(Foo_GetFileName(), '.*\\\([^\\]\+\)', '\1', '')<cr>
imap <M-z> <C-R>=substitute(Foo_GetFileName(), '.*\\\([^\\]\+\)', '\1', '')<cr>

cmap <M-g> <C-R>=fnamemodify(Foo_GetFileName(), ":t")<CR>
nnoremap gx :let @*=GetCursorFileName()<CR>

nnoremap <silent> <M-r> :call <SID>RefreshIfNotMod()<cr>
map so :<C-\>eFoo_Opendir("sp")<cr>
map vsp :<C-\>eFoo_Opendir("vsp")<cr>
map <M-o> :<C-\>eFoo_Opendir("e")<cr>
nnoremap vc :call <SID>Foo_OpenCurWindow()<cr>

nnoremap <M-l> :execute("wincmd p")<cr>

nnoremap <silent> gm :call Foo_Open_Only_One($VIM . '\map.vim')<cr>
nnoremap <silent> gv :call Foo_Open_Only_One($VIM . '\_vimrc')<cr>
nnoremap <silent> gb :call Foo_Open_Only_One($VIM.'\tools\boxes.cfg')<CR>
nnoremap <silent> gz :call Foo_Open_Only_One('plugin/commonfunc.vim')<cr>
nnoremap <silent> gs :call Foo_Open_Only_One('D:\skill\programming\jquery\books\learning.jquery\4th\code\chapter 12\index.html')<cr>
nnoremap <silent> gn :call Foo_Open_Only_One('D:\skill\autohotkey\ahk.bat')<cr>
nnoremap gch :call <SID>Foo_CopyName("dir",'cygwin')<cr>
nnoremap gcp :call <SID>Foo_CopyName("full",'cygwin')<cr>
nnoremap gp :call <SID>Foo_CopyName("full")<cr>
nnoremap gup :call <SID>Foo_CopyName("full",'unix')<cr>
nnoremap guh :call <SID>Foo_CopyName("dir",'unix')<cr>
nnoremap gh :call <SID>Foo_CopyName("dir")<cr>

nnoremap em :call <SID>Foo_CreateDirFile('mkdir')<cr>
nnoremap et :call <SID>Foo_CreateDirFile('touch')<cr>
nnoremap mv :call <SID>Foo_MoveFile()<cr>
nnoremap eg :call <SID>Foo_Grepstring()<cr>

cnoremap <C-l> <C-R>=g:Foo_LastWinDir<cr>
map <M-;> :call <SID>Foo_Max_last_two_window()<cr>
map <M-2> :call <SID>Foo_Max_last_two_window()<cr>
map <M-cr> :call <SID>Foo_Max_last_two_window()<cr>
nnoremap <silent> gf :call Foo_GotoFile("s")<cr>
nnoremap <silent> go :call Foo_GotoFile("o")<cr>
nnoremap <silent> gd :call Foo_GotoFile("d")<cr>

nnoremap ec :call <SID>Foo_CopyFile()<cr>
nnoremap er :call <SID>Foo_DelFile()<cr>

nnoremap <M-c> :<C-\>eFoo_Test('c:\Program Files\')<cr>
nnoremap <M-i> :<C-\>eFoo_Test($VIMRUNTIME.'\indent\')<cr>
nnoremap <M-d> :<C-\>eFoo_Test('d:\skill\')<cr>
nnoremap <M-e> :<C-\>eFoo_Test('e:\skill\')<cr>
"nnoremap <M-e> :call Foo_Open_Only_One('C:\Documents and Settings\afj\.vimfavourites')<cr>
nnoremap <M-z> :call Foo_Open_Only_One('C:\Documents and Settings\afj\.vimfavourites')<cr>
nnoremap <M-u> :call <SID>Foo_UnCloseLastWindow()<cr>

autocmd WinLeave * :call <SID>Foo_Record_Last_WinInfo()
autocmd BufWinLeave * :let g:lastClosedName=expand("%:p")
