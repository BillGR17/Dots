" create a session only if there is no argument on nvim call
if argc() == 0
  if !empty(glob('.session.vim~'))
     au VimEnter * nested so .session.vim~|cal delete('.session.vim~')
  en
  au VimLeavePre * cal s:ClearEmpty()
en
" close all empty windows before saving session
fu s:ClearEmpty()
  let s:windows=0
  " close empty windows before saving session
  windo if (line('$') == 1 && getline(1) == '') | clo | en
  " count remaining windows
  windo let s:windows+=1
  " don't bother saving session for 1 window
  if (s:windows>1)
    mks! .session.vim~
  en
endf
" keep tabs and window sizes on session.vim~
se ssop=tabpages,winsize
