if exists('g:loaded_find_everything')
   finish
endif
let g:loaded_find_everything = 1

if !exists('g:fe_es_option')
  " let g:fe_es_option = '-w'
   let g:fe_es_option = '-p'
   " let g:fe_es_option = '-s'
   " let g:fe_es_option = '-s -r'
endif

if !exists("g:fe_es_option_reg")
  " let g:fe_es_option_reg = '-s -r'
  let g:fe_es_option_reg = '-p -r'
endif

"Map_Keys {{{
fun! s:Map_Keys()
  " nnoremap <buffer> <silent> <CR>
   "          \ :call <SID>Open_Everything_File('filter')<CR>
   nnoremap <buffer> <silent> <2-LeftMouse>
            \ :call <SID>Open_Everything_File('external')<CR>
   nnoremap <buffer> <silent> <C-CR>
            \ :call <SID>Open_Everything_File('internal')<CR>
   " nnoremap <buffer> <silent> <ESC> :close<CR>
endfun
"}}}
"Show_Everything_Result {{{
fun! s:Show_Everything_Result(result)
   let bname = '_Everything_Search_Result_'
   " If the window is already open, jump to it
   let winnum = bufwinnr(bname)
   if winnum != -1
      if winnr() != winnum
         " If not already in the window, jump to it
         exe winnum . 'wincmd w'
      endif
      setlocal modifiable
      " Delete the contents of the buffer to the black-hole register
      silent! %delete _
   else
      let bufnum = bufnr(bname)
      if bufnum == -1
         let wcmd = bname
      else
         let wcmd = '+buffer' . bufnum
      endif
      exe 'silent! botright ' . '8' . 'split ' . wcmd
   endif
   " Mark the buffer as scratch
   setlocal buftype=nofile
   "setlocal bufhidden=delete
   setlocal noswapfile
   setlocal nowrap
   setlocal nobuflisted
   setlocal winfixheight
   setlocal modifiable

   " Setup the cpoptions properly for the maps to work
   let old_cpoptions = &cpoptions
   set cpoptions&vim
   " Create a mapping
   call s:Map_Keys()
   " Restore the previous cpoptions settings
   let &cpoptions = old_cpoptions
   " Display the result
   silent! %delete _
   silent! 0put =a:result

   " Delete the last blank line
   silent! $delete _
   " Move the cursor to the beginning of the file
   normal! gg
   setlocal nomodifiable
endfun
"}}}

func! MyFindEverything() "{{{
  let prg = g:fe_es_exe
  let pat = input (g:fe_es_exe . ' ' . g:fe_es_option . ' ')
  if pat =~ "[$^*]"
    let opt = g:fe_es_option_reg
  else
    let opt = g:fe_es_option
  endif
  let pat = substitute(pat, '^\s*', '', '')
  let pat = substitute(pat, '\s$', '', '')
  
  if -1 != match(pat, ' ')
    let quote = '""'
  else
    let quote = '"'
  endif

  " let pat = substitute(pat, '\n', '', '')
  if "" == pat
    return
  endif
  if "" != matchstr(opt, "-r")
    " 这个必须在前面，先将.转义
    let pat = substitute(pat, '\.', '\\.', 'g')
    let pat = substitute(pat, '*', '.*', 'g')
  endif
    
  " let pat = '"' . pat . '"'
  " let pat = '""' . pat . '""'
  let cmd = prg . ' ' . opt . ' ' . quote . pat . quote 

  let l:result=system(cmd)

  " if empty(l:result)
  if ("" == l:result)
    echoh Error | echo "No files found!" | echoh None
    return
  endif
  if matchstr(l:result, 'Everything IPC window not found, IPC unavailable.') != ""
    echoh Error | echo "Everything.exe is not running!" | echoh None
    return
  endif

  " Show results
  call s:Show_Everything_Result(l:result)

endf
"}}}

func MyFindCurdir()
  let cmd='D:\skill\Apps\Everything\Everything.exe'
  let param=" -search " . '"' . getcwd() . ' "'
  silent exec '!start ' . cmd . param 
endf

nnoremap ef :call MyFindEverything()<cr>
nnoremap <C-f> :call MyFindCurdir()<cr>
