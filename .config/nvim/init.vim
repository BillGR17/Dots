if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/autoload')
" Better Lang support
  Plug 'mustache/vim-mustache-handlebars'
" Better Lang Syntax
  Plug 'jelera/vim-javascript-syntax'
  Plug 'octol/vim-cpp-enhanced-highlight'
" Tools
  Plug 'w0rp/ale'
  Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}
  Plug 'Shougo/neosnippet'
  Plug 'Shougo/neosnippet-snippets'
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

let NERDTreeShowHidden=1
" vim nerdtree on start or restore session
if argc() == 0 
  if !empty(glob('.session.vim~'))
     au VimEnter * so .session.vim~
     au VimEnter * call timer_start(500, { tid -> execute('windo e|NERDTree')})
  endif
  au VimLeavePre * NERDTreeClose
  au VimLeavePre * mks! .session.vim~
endif

au VimEnter * NERDTree
au VimEnter * wincmd p

" lightline
let g:lightline={
\ 'colorscheme':'nord',
\}

" Cpp settings
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1
let g:cpp_experimental_simple_template_highlight=1
let g:cpp_experimental_template_highlight=0
let g:cpp_concepts_highlight=1

" highlight closing tag "
let g:mta_filetypes={
\ 'html':1,
\ 'html.handlebars':1
\}

" vim gitgutter settings
let g:gitgutter_realtime=1
let g:gitgutter_eager=0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'
let g:user_emmet_install_global=0
au FileType html,html.handlebars EmmetInstall

" deoplete
let g:deoplete#enable_at_startup=1

" neosnippet
im <expr><TAB>
\ pumvisible() ? "\<C-n>" :
\ neosnippet#expandable_or_jumpable() ?
\    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

let g:neosnippet#enable_completed_snippet=1

" vim ale config
let g:ale_open_list=1

syn on
set ph=20 wim=full mouse=a si nu lz sm bk ut=100
set cuc cul ts=2 shiftwidth=2 sts=2 et spell nowrap udf
set list lcs=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

" Greek keymap support & Encoding
set fenc=utf-8 kmp=greek_utf-8 imi=0 ims=-1

" Theme Settings
set tgc
colo nord

" read stylus as css
au BufRead *.styl set syntax=css ft=css

" Quick split with ctr + arrow
nm <silent> <C-Right> :vs<CR>:wincmd l<CR>
nm <silent> <C-Down> :sp<CR>:wincmd j<CR>
nm <silent> <C-Up> :sp<CR>:wincmd R<CR>wincmd k<CR>
nm <silent> <C-Left> :vs<CR>
" change window with alt + arrow
nm <silent> <A-Up> :wincmd k<CR>
nm <silent> <A-Down> :wincmd j<CR>
nm <silent> <A-Left> :wincmd h<CR>
nm <silent> <A-Right> :wincmd l<CR>
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
vm <Tab> :s/^/  /g<CR>:nohls<CR>
vm <S-Tab> <<CR>
" Trim whitespace
nm <F2> :%s/\s\+$//e<CR>
" Tabs to spaces
nm <F3> :%s/\t/  /g<CR>
" Refresh Settings
nm <silent> <F5> :so $MYVIMRC<CR>
" Save Project
nm <C-s> :w<CR>
im <C-s> <ESC> :w<CR>
" Toggle Nerdtree
nm <silent> <C-\> :NERDTreeToggle<CR>
im <silent> <C-\> <ESC> :NERDTreeToggle<CR>
" Fix Syntax
nm <silent> <F12> :syntax sync fromstart<CR>
im <silent> <F12> <ESC> :syntax sync fromstart<CR>
" Show Collors
nm <silent> <F11> :ColorHighlight<CR>
im <silent> <F11> <ESC> :ColorHighlight<CR>
