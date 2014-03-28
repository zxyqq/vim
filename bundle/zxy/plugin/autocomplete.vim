if exists("loaded_autocomplete")
  finish
endif

let loaded_autocomplete=1

function! SuperCleverTab()
  "check if at beginning of line or after a space

  if pumvisible()
    return "\<c-n>"
  endif

  if strpart( getline('.'), 0, col('.')-1 ) =~ '^\s*$'
    return "\<Tab>"
  else
    " do we have omni completion available
    if &dictionary != ''
      "use omni-completion 1. priority
      return "\<C-X>\<C-K>"
    elseif &omnifunc != ''
      " no omni completion, try dictionary completio
      return "\<C-X>\<C-O>"
    else
      "use omni completion or dictionary completion
      "use known-word completion
      return "\<C-X>\<C-N>"
    endif
  endif
endfunction

