if empty(glob('~/.config/nvim/autoload/plug.vim'))
  sil !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
en
call plug#begin('~/.config/nvim/autoload')
  " Better Lang Syntax
  Plug 'sheerun/vim-polyglot'
  " Tools
  Plug 'dense-analysis/ale'
  Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}
  Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh' }
  Plug 'mattn/emmet-vim'
  Plug 'terryma/vim-multiple-cursors'
  " UI & Tools
  Plug 'valloric/MatchTagAlways'
  Plug 'airblade/vim-gitgutter'
  Plug 'scrooloose/nerdtree'
  Plug 'itchyny/lightline.vim'
  Plug 'arcticicestudio/nord-vim'
  Plug 'chrisbra/Colorizer'
call plug#end()
" load or create session if Vim doesn't have any arguments
if argc() == 0
  if !empty(glob('.session.vim~'))
     au VimEnter * so .session.vim~|echo delete('.session.vim~')
  en
  au VimLeavePre * tabdo NERDTreeClose|if empty(&buftype) | mks! .session.vim~ | en
en
fu Nerd_tog()
  NERDTreeToggle
  wincmd p
  " if file exist in the disk then NERDTreeFind will find it
  if filereadable(expand(@%)) != 0
    NERDTreeFind
    wincmd p
  en
endf
au VimEnter * call Nerd_tog()

let NERDTreeShowHidden=1
let NERDTreeMapOpenInTab='<ENTER>'

let g:polyglot_disabled = ['styl']

" read stylus as css 
au BufRead *.styl set syntax=css ft=css

" lightline
let g:lightline={'colorscheme':'nord'}

" highlight closing tag "
let g:mta_filetypes={
  \'html':1,
  \'html.handlebars':1,
  \'html.twig':1,
  \'php':1
\}

" vim gitgutter settings
let g:gitgutter_realtime=1
let g:gitgutter_eager=0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'
let g:user_emmet_install_global=0
au FileType html,html.*,php EmmetInstall

" deoplete
let g:deoplete#enable_at_startup=1

" vim ale config
let g:ale_open_list=1
let g:ale_linters = {
  \'c': ['clang'],
  \'javascript': ['eslint']
\}
let g:ale_pattern_options = {'.*\.hbs$': {'ale_enabled': 0}}
aug CloseLoclistWindowGroup
  au!
  au QuitPre * if empty(&buftype) | lcl | en
aug END

syn on
set ph=20 wim=full mouse=a si nu lz sm ut=100 title ssop-=blank,options,buffer
set cot-=preview cuc cul ts=2 shiftwidth=2 sts=2 et spell nowrap udf 
set list lcs=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

" Greek keymap support & Encoding
set fenc=utf-8 kmp=greek_utf-8 imi=0 ims=-1

" Theme Settings
set tgc
colo nord

" Remove empty whitespace
au FileType c,cpp,go,css,sass au BufWritePre <buffer> %s/\s\+$//e

" this function saves cursor position and executes beautify and deletes empty lines
fu B_C(_file)
  if line('$') > 1
    " current position¬
    let _c_c=getpos(".")
    if a:_file=="js"
      sil! undoj|sil! exe "%!js-beautify -s 2"|sil! g/^$/d
    elsei a:_file=="ht"
      sil! undoj|sil! exe "%!js-beautify -s 2 --type html"|sil! g/^$/d
    elsei a:_file=="cs"
      sil! undoj|sil! exe "%!js-beautify -s 2 --type css"|sil! g/^$/d
    elsei a:_file=="c"
      sil! undoj|sil! exe "%!clang-format --style=file"|sil! g/^$/d
    en
    " move to current position after done executing¬
    call setpos(".",_c_c)
    unl _c_c
  en
endf
" if js-beautify exist beautify code on every save¬
if executable("js-beautify")
  au FileType javascript.jsx,json,javascript au BufWrite *.js,*.json call B_C("js")
  au FileType html,html.handlebars au BufWrite *.html,*.hbs call B_C("ht")
  au FileType css au BufWritePre *.css call B_C("cs")
en
" if clang-format exist beautify code on every save¬
if executable("clang-format")
  au FileType c,cpp au BufWritePre *.c,*.cpp call B_C("c")
en
" completions
im <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
" Quick split with ctr + arrow
nm <silent> <C-A-Right> :vs<CR>:wincmd l<CR>
nm <silent> <C-A-Down> :sp<CR>:wincmd j<CR>
nm <silent> <C-A-Up> :sp<CR>:wincmd R<CR>wincmd k<CR>
nm <silent> <C-A-Left> :vs<CR>
" change window with alt + arrow
nm <silent> <A-Up> :wincmd k<CR>
nm <silent> <A-Down> :wincmd j<CR>
nm <silent> <A-Left> :wincmd h<CR>
nm <silent> <A-Right> :wincmd l<CR>
" Quick move line
nm <C-Up> :m-2<CR>
nm <C-Down> :m+<CR>
im <C-Up> <Esc>:m .-2<CR>==gi
im <C-Down> <Esc>:m .+1<CR>==gi
vm <C-Up> :m '<-2<CR>gv=gv
vm <C-Down> :m '>+1<CR>gv=gv
" auto close brackets
im ( ()<left>
im [ []<left>
im { {}<left>
im < <><left>
" inverse tab using shift-tab
ino <S-Tab> <C-d>
nn <S-Tab> <<
" tab in Normal mode
nn <Tab> >>
" tab on selection
vm <Tab> :s/^/  /g<CR>:nohls<CR>gv
vm <S-Tab> <gv
" Trim whitespace
nm <F2> :%s/\s\+$//e<CR>
" Tabs to spaces
nm <F3> :%s/\t/  /g<CR>
" Save Project
nm <C-s> :w<CR>
im <C-s> <ESC> :w<CR>
" Toggle Nerdtree
nm <silent> <C-\> :NERDTreeToggle<CR>
im <silent> <C-\> <ESC> :NERDTreeToggle<CR>
" Fix Syntax
nm <silent> <F12> :NERDTreeClose <bar> :windo e! <bar> :NERDTreeFind <bar> :wincmd p<CR>
" Show Collors
nm <silent> <F11> :ColorHighlight<CR>
im <silent> <F11> <ESC> :ColorHighlight<CR>
