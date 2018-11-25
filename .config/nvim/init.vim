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
  Plug 'tpope/vim-fugitive'
  Plug 'airblade/vim-gitgutter'
  Plug 'scrooloose/nerdtree'
  Plug 'itchyny/lightline.vim'
  Plug 'cocopon/iceberg.vim'
call plug#end()

" vim nerdtree on start
au VimEnter * NERDTree
au VimEnter * wincmd p
let NERDTreeShowHidden=1

" Cpp settings
let g:cpp_class_scope_highlight=1
let g:cpp_member_variable_highlight=1
let g:cpp_class_decl_highlight=1
let g:cpp_experimental_simple_template_highlight=1
let g:cpp_experimental_template_highlight=0
let g:cpp_concepts_highlight=1

" lightline
let g:lightline = {
\ 'colorscheme':'iceberg',
\ }

" highlight closing tag "
let g:mta_filetypes = {
\ 'html':1,
\ 'xhtml':1,
\ 'ejs':1,
\ 'html.twig':1,
\ 'html.handlebars':1
\}

" vim gitgutter settings
let g:gitgutter_realtime=1
let g:gitgutter_eager=0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'
let g:user_emmet_install_global=0
au FileType html,css,styl,hbs,html.handlebars,ejs,html.twig EmmetInstall

" deoplete
call deoplete#enable()

" neosnippet
im <expr><TAB> neosnippet#expandable_or_jumpable()?
\"\<Plug>(neosnippet_expand_or_jump)"
\:pumvisible() ? "\<C-n>":"\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable()?
\"\<Plug>(neosnippet_expand_or_jump)"
\:"\<TAB>"

if has('conceal')
  set cole=2 cocu=niv
endif

let g:neosnippet#enable_completed_snippet=1
let g:neosnippet#enable_snipmate_compatibility=1

" vim ale config
let g:ale_open_list=1

syntax on filetype plugin indent on
set ar ph=20 wim=full mouse=a clipboard=unnamedplus si nu lz sm bk ut=100
set cuc cul ts=2 shiftwidth=2 sts=2 et spell
set list lcs=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.

" Greek keymap support & Encoding
set fenc=utf-8 kmp=greek_utf-8 imi=0 ims=-1

" Theme Settings
set bg=dark tgc
colo iceberg

" read stylus as css
au BufRead *.styl set syntax=css

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
" Trim whitespaces
nm <F4> :%s/\s\+$//e<CR>
" Tabs to spaces
nm <F5> :%s/\t/  /g<CR>
" 4 spaces to 2
nm <F6> :'<,'>s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<CR>
" Save Project
nm <C-s> :w<CR>
im <C-s> <ESC> :w<CR>
" Toggle Nerdtree
nm <silent> <C-\> :NERDTreeToggle<CR>
im <silent> <C-\> <ESC> :NERDTreeToggle<CR>
