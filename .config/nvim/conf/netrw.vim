fu Toggle_netrw()
  sil! Lex|winc p
endf
fu Change_map()
  " Minor mouse fixes
  nm <buffer> <2-LeftMouse> <nop>
  nm <buffer> <LeftDrag> <cr>
endf
" commands
au Filetype netrw cal Change_map()
au VimEnter * cal Toggle_netrw()
au VimLeavePre * cal Toggle_netrw()
" Keysmaps
nm <silent> <C-\> :cal Toggle_netrw()<CR>
im <silent> <C-\> :cal Toggle_netrw()<CR>
" Settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 15
let g:netrw_wiw = 15
let g:netrw_keepdir = 0
let g:netrw_hide = 0
let g:netrw_browse_split = 4
let g:netrw_fastbrowse = 0
