fu Toggle_netrw()
  sil! Lex %:p:h|se nosmd|winc p
endf
fu Change_map()
  " Minor mouse fixes
  nm <buffer> <2-LeftMouse> <cr>
  nm <buffer> <MiddleMouse> <c-l>
  nm <buffer> <LeftDrag> <cr>
endf
fu Close_netrw()
  windo if (&ft=='netrw') | clo | en
endf
" commands
au VimEnter * cal Toggle_netrw()
au VimLeave * cal Close_netrw()
au Filetype netrw cal Change_map()
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
