if exists("b:did_zxy_plugin")
  finish
endif
let b:did_zxy_plugin = 1


noremap <buffer> <2-LeftMouse> :exe "tag ". expand("<cword>")<CR>
nnoremap <buffer> <RightMouse> :call GotoParentdirOrHead()<cr>

