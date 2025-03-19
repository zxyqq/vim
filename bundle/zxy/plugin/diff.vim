let s:File=expand("<sfile>:h")."/diff.log"
func! BCDiffThis()
	call DiffThis("c:/Apps/BeyondCompare4PE/BCompare.exe", "")
endf

func! WMDiffThis()
	call DiffThis("c:/Apps/WinMerge/WinMergeU.exe", "/e /s")
endf

func! DiffThis(cmd,opt)
	let list = readfile(s:File, '', 1)
	if(empty(list))
		call writefile([expand("%:p")], s:File)
	else
		let diffThis1 = list[0]
		let diffThis2=expand("%:p")
		let cmd="silent !start ". a:cmd . ' ' . a:opt . ' "'. diffThis1.'"'. ' "'. diffThis2.'"'
		execute(cmd)
		call writefile([], s:File)
	endif
endf
nmap <F11> :call BCDiffThis()<cr>
