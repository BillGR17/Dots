if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.config/nvim/autoload')
" Better Lang support
  Plug 'mustache/vim-mustache-handlebars'                     " for hbs template engine
  Plug 'lumiliet/vim-twig'                                    " for twig template engine
  Plug 'vim-scripts/vim-stylus'                               " for stylus
" Better Lang Syntax
  Plug 'jelera/vim-javascript-syntax'                         " for better javascript syntax
  Plug 'octol/vim-cpp-enhanced-highlight'                     " for better c++ syntax
" Tools
  Plug 'w0rp/ale'                                             " for Async linter
  Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}   " for better completion
  Plug 'Shougo/neosnippet'                                    " For func argument completion
  Plug 'Shougo/neosnippet-snippets'                           " For func argument completion
  Plug 'mattn/emmet-vim'                                      " emmet for vim
  Plug 'terryma/vim-multiple-cursors'                         " Multiple cursors
" UI & Tools
  Plug 'valloric/MatchTagAlways'                              " for showing matched tags html hbs twig
  Plug 'tpope/vim-fugitive'                                   " for git
  Plug 'airblade/vim-gitgutter'                               " for git
  Plug 'scrooloose/nerdtree'                                  " Left sidebar with file management
  Plug 'itchyny/lightline.vim'                                " for the status bar
  Plug 'cocopon/iceberg.vim'                                  " theme for vim
call plug#end()

" vim nerdtree on start
au VimEnter * NERDTree
au VimEnter * wincmd p                                        " dont focus on nerdtree on open
let NERDTreeShowHidden=1                                      " show hidden files

" Cpp settings
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 0
let g:cpp_concepts_highlight = 1

" lightline
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ }

" highlight closing tag "
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'ejs' : 1,
    \ 'html.twig' : 1,
    \ 'html.handlebars' : 1
    \}

" vim gitgutter settings
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'
let g:user_emmet_install_global = 0
au FileType html,css,styl,hbs,html.handlebars,ejs,html.twig EmmetInstall

" deoplete
call deoplete#enable()

" neosnippet
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)"
 \: "\<TAB>"

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#enable_completed_snippet = 1
let g:neosnippet#enable_snipmate_compatibility = 1


" vim ale config
let g:ale_open_list = 1                                         " Opens the quickfix for more details on the warnings or errors

" vim settings
syntax on
filetype plugin indent on
set ar                                                          " Auto refresh file on change from outside
set ph=20                                                       " Limit popup menu height
set wim=full                                                    " better wild menu
set mouse=a                                                     " Mouse Support
set clipboard=unnamedplus                                       " Copy to Clipboard
set si                                                          " Automatically inserts one extra level of indentation in some cases
set ts=2 shiftwidth=2 sts=2 et                                  " Tabs Settings
set cuc cul                                                     " Creates a cross around the cursor
set nu                                                          " Shows Line numbers on left
set lz                                                          " Fixes render also faster render
set sm                                                          " Shows matching parentheses and stuff
set bk                                                          " Backup
set fenc=utf-8                                                  " Encoding fix
set list                                                        " Show whitespace and stuff
set lcs=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.       " Sets the icons for list
set ut=100                                                      " Sets Vims Update to 100 ms instead of 4 secs
set spell                                                       " Spell Check

" Theme Settings
set bg=dark
colo iceberg
set tgc                                                         " enables terminal colors

" Vim custom key commands

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
mm <F4> :%s/\s\+$//e<CR>
" Tabs to spaces
nm <F5> :%s/\t/  /g<CR>
" 4 spaces to 2
nm <F6> :%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<CR>

" Save Project
nm <C-s> :w<CR>
im <C-s> <ESC> :w<CR>
