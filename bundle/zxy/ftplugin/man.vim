if exists("b:did_zxy_plugin") | finish | endif
let b:did_zxy_plugin = 1

nmap <buffer> ,mc !!boxes -d donote <CR>==j
vmap <buffer> ,mc mz!boxes -d donote <CR>='zj
nmap <buffer> ,xc !!boxes -d donote -r<CR>==j
vmap <buffer> ,xc mz!boxes -d donote -r<CR>='zj

