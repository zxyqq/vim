if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

nmap <buffer> ,mc !!boxes -d donote <CR>==j
vmap <buffer> ,mc mz!boxes -d donote <CR>='zj
nmap <buffer> ,xc !!boxes -d donote -r<CR>==j
vmap <buffer> ,xc mz!boxes -d donote -r<CR>='zj
" When formatting text, recognize numbered lists.  The indent of the
" text after the number is used for the next line

nnoremap <buffer>  ,ma !!boxes -d do-cmt<CR>==
vnoremap <buffer>  ,ma mz!boxes -d do-cmt<CR>='z
nnoremap <buffer>  ,xa !!boxes -d do-cmt -r<CR>==
vnoremap <buffer>  ,xa mz!boxes -d do-cmt -r<CR>='z

setlocal softtabstop=4
setlocal shiftwidth=4
setlocal fo+=2n
" setlocal expandtab
setlocal noexpandtab
setlocal ff=unix
