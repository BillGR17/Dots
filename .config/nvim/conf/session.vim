" create a session only if there is no argument on nvim call
if argc() == 0
  if !empty(glob('.session.vim~'))
     au VimEnter * so .session.vim~|echo delete('.session.vim~')
  en
  au VimLeavePre * if empty(&buftype)|mks! .session.vim~|en
en
" keep tabs and window sizes on session.vim~
se ssop=tabpages,winsize
