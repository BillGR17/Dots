fu Nerd_tog()
  NERDTreeToggle
  wincmd p
  " if file exist in the disk then NERDTreeFind will find it
  if filereadable(expand(@%)) != 0 && g:NERDTree.IsOpen()
    NERDTreeFind
    wincmd p
  en
endf
au VimEnter * call Nerd_tog()
let g:NERDTreeStatusline = '%#NonText#'
let NERDTreeIgnore=[]
let NERDTreeShowHidden=1
let NERDTreeMapOpenInTab='<ENTER>'
"always close nerdtree before vim close
au VimLeavePre * NERDTreeClose
" Toggle Nerdtree
nm <silent> <C-\> :call Nerd_tog()<CR>
im <silent> <C-\> <ESC> :call Nerd_tog()<CR>
