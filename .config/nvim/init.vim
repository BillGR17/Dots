let skip_defaults_vim=1                                       " Removes all vim Default Configs
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
  Plug 'mustache/vim-mustache-handlebars'                     " for hbs template engine
  Plug 'lumiliet/vim-twig'                                    " for twig template engine
  Plug 'vim-scripts/vim-stylus'                               " for stylus
  Plug 'valloric/MatchTagAlways'                              " for showing matched tags html hbs twig
  Plug 'jelera/vim-javascript-syntax'                         " for better javascript syntax
  Plug 'octol/vim-cpp-enhanced-highlight'                     " for better c++ syntax

  Plug 'tpope/vim-fugitive'                                   " for git
  Plug 'airblade/vim-gitgutter'                               " for git

  Plug 'scrooloose/nerdtree'                                  " Left sidebar with filemanagement

  Plug 'w0rp/ale'                                             " for Async linter

  Plug 'Shougo/deoplete.nvim',{'do':':UpdateRemotePlugins'}   " for better completion

  Plug 'SirVer/ultisnips'                                     " for snippets
  Plug 'honza/vim-snippets'                                   " ~~

  Plug 'majutsushi/tagbar'                                    " for quick look at functions
  Plug 'mattn/emmet-vim'                                      " emmet for vim
  Plug 'terryma/vim-multiple-cursors'                         " Multiple curors

  Plug 'itchyny/lightline.vim'                                " for the status bar
  Plug 'cocopon/iceberg.vim'                                  " theme for  vim

call plug#end()

" vim nerdtree on start
au vimenter * NERDTree
au VimEnter * wincmd p                                        " dont focus on nerdtree on open
let NERDTreeShowHidden=1                                      " show hidden files

" Cpp settings
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 0
let g:cpp_concepts_highlight = 1

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

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"
let g:UltiSnipsEditSplit="vertical"

" vim gitgutter settings
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'

" deoplete
let g:deoplete#enable_at_startup = 1

" vim ale config
let g:ale_open_list = 1                                         " Opens the quickfix for more details on the warnings or errors

" vim settings
syntax on
filetype plugin indent on
set autoread                                                    " Auto refresh file on change from outside
set pumheight=20                                                " Limit popup menu height
set wim=full                                                    " better wild menu
set completeopt=longest,menuone
set mouse=a                                                     " Mouse Support
set clipboard=unnamedplus                                       " Copy to Clipboard
set autoindent                                                  " Does nothing more than copy the indentation from the previous line, when starting a new line.
set smartindent                                                 " Automatically inserts one extra level of indentation in some cases, and works for C-like files. fcs up stylus :)
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab              " Tabs Settings
set cursorcolumn cursorline                                     " Creates a cross around the cursor
set number                                                      " Shows Line numbers on left
set showcmd                                                     " Show Command line
set lazyredraw                                                  " Fixes render also faster render
set showmatch                                                   " Shows matching parentheses and stuff
set incsearch                                                   " Shows the next match while entering a search
set backup                                                      " Backup settings starts here
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup                                                 " Backup settings  ends here
set encoding=utf-8                                              " Encoding fix
set fileencoding=utf-8                                          " Encoding fix
set list                                                        " Show whitespace and stuff
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:. " Sets the icons for list
set updatetime=100                                              " Sets Vims Update to 100 ms instead of 4 secs
set spell                                                       " Spell Check

" Theme Settings
set background=dark
colorscheme iceberg
set tgc                                                         " enables terminal colors



" Vim custom key commands

" auto close brackets
imap ( ()<left>
imap [ []<left>
imap { {}<left>
imap < <><left>

" Tabs to spaces
nmap <F5> :%s/\t/  /g<CR>
" 4 spaces to 2
nmap <F6> :%s;^\(\s\+\);\=repeat(' ', len(submatch(0))/2);g<CR>

" Save Project
nmap <C-s> :w<CR>
imap <C-s> <ESC> :w<CR>

" Close Tab
nmap <C-w> :q<CR>
imap <C-w> <ESC> :q<CR>

" Vim  commands to execute each time you go to normal mode
au BufWritePre * :%s/\s\+$//e                                   " Trim spaces
