if exists("b:did_html_after_ftplugin")
  finish
endif
let did_html_after_ftplugin = 1

" Let the matchit plugin know what items can be matched.
if exists("b:match_words")
  let b:match_ignorecase = 0
  let b:match_words = '<:>,{:},(:),[:]' . b:match_words
endif
