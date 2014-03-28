if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

" Set 'formatoptions' to break comment lines but not other lines,
" and insert the comment leader when hitting <CR> or using "o".
setlocal fo-=t fo+=croql
set com=n:',b:'

nmap <buffer> ,mc !!boxes -d vb-cmt <CR>==j
vmap <buffer> ,mc mz!boxes -d vb-cmt <CR>='zj
nmap <buffer> ,xc !!boxes -d vb-cmt -r<CR>==j
vmap <buffer> ,xc mz!boxes -d vb-cmt -r<CR>='zj

" D:\PortableApps\vim\vim73\ftplugin\vb.vim
" let b:match_words = '\%(\<End\s\+\)\@<!\<Function\>:\<End\s\+Function\>,'
"       \ . '\%(\<End\s\+\)\@<!\<Sub\>:\<End\s\+Sub\>,'
"       \ . '\%(\<End\s\+\)\@<!\<if\>:\<Else\>:\<End\s\+If\>,'
"       \ . '\<While\>:\<Wend\>'
