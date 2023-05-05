fu Toggle_netrw()
  sil! Lex|winc p
endf
" commands
au VimEnter * call Toggle_netrw()
au VimLeavePre * call Toggle_netrw()
" Keysmaps
nm <silent> <C-\> :call Toggle_netrw()<CR>
im <silent> <C-\> :call Toggle_netrw()<CR>
" Settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 15
let g:netrw_wiw = 15
let g:netrw_keepdir = 0
let g:netrw_hide = 0
let g:netrw_browse_split = 4
let g:netrw_fastbrowse = 0
