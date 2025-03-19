"gx is ok, no need here
"if exists("loaded_Bar")
	"finish
"endif

"let loaded_Bar=1

""let g:ExploreExtList=[".chm.", ".exe."]
"let g:ExploreExtList='.chm;.exe;.docx;'

"function! Bar_ExplFileHandlerWin32(fn)
	"silent exec '!start rundll32 url.dll,FileProtocolHandler "'
				"\ . escape(a:fn, '%#') . '"'
"endfunction

"function! Mapgf()
	"let fn=expand("<cfile>")
	"let extension = fnamemodify(fn, ":t:e")
	"if (extension!="")&& match(g:ExploreExtList, ".".extension.";")!=-1
		"call Bar_ExplFileHandlerWin32(escape(fn,'!'))
		"return
	"else
		"silent! execute("sfind ".fn)
		""silent! execute("normal gf")
	"endif
"endf

""nnoremap <silent> gf :call Mapgf()<cr>
""nnoremap <silent> go :call Mapgf()<cr>
