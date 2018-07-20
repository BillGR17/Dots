set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/plugged')
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'tpope/vim-fugitive'
  Plug 'scrooloose/nerdtree'
  Plug 'valloric/youcompleteme'
  Plug 'airblade/vim-gitgutter'
  Plug 'majutsushi/tagbar'
  Plug 'scrooloose/syntastic'
  Plug 'SirVer/ultisnips'
  Plug 'mattn/emmet-vim'
  Plug 'ervandew/supertab'
  Plug 'vim-scripts/vim-stylus'
  Plug 'jelera/vim-javascript-syntax'
  Plug 'townk/vim-autoclose'
  Plug 'moll/vim-node'
  Plug 'rip-rip/clang_complete'
  Plug 'octol/vim-cpp-enhanced-highlight'
  Plug 'bling/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'valloric/MatchTagAlways'
  Plug 'arcticicestudio/nord-vim'
call plug#end()

" vim nerdtree on start
au vimenter * NERDTree
au VimEnter * wincmd p "dont focus on nerdtree on open
let NERDTreeShowHidden=1 "show hidden files

" Recommended settings from syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" javascript config
let g:syntastic_javascript_checkers = ['eslint']            " install esling with sudo npm i -g eslint or from linux pacages
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1


" c++ config
let g:clang_use_library = 1                                 " Use libclang directly
let g:clang_library_path ='/usr/lib64/libclang.so'          " Path to the libclang on the system
let g:clang_complete_auto = 1                               " Run autocompletion immediatelly after ->, ., ::
let g:clang_complete_copen = 1                              " Open quickfix window on error
let g:clang_periodic_quickfix = 1                           " Turn-off periodic updating of quickfix window (g:ClangUpdateQuickFix() does the same)
let g:clang_snippets = 1                                    " Enable function args autocompletion, template parameters, ...
let g:clang_snippets_engine = 'ultisnips'                   " Use UltiSnips engine for function args autocompletion (provides mechanism to jump over to the next argument)
let g:clang_conceal_snippets = 1                            " clang_complete engine related setting


let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1

" airline config
let laststatus=2
let g:airline_powerline_fonts = 0                           " Use Powerline fonts to show beautiful symbols
let g:airline_theme='deus'                                   " Select 'murmur' theme as default one
let g:airline_inactive_collapse = 0                         " Do not collapse the status line while having multiple windows
let g:airline#extensions#whitespace#enabled = 0             " Do not check for whitespaces
let g:airline#extensions#tabline#enabled = 0                " Do not Display tab bar with buffers
let g:airline#extensions#branch#enabled = 1                 " Enable Git client integration
let g:airline#extensions#tagbar#enabled = 1                 " Enable Tagbar integration
let g:airline#extensions#hunks#enabled = 1                  " Enable Git hunks integration
" https://vi.stackexchange.com/a/3363
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" highlight closing tag "
let g:mta_filetypes = {
    \ 'html' : 1,
    \ 'xhtml' : 1,
    \ 'hbs' : 1,
    \ 'ejs' : 1,
    \ 'html.handlebars' : 1
    \}

" Snips config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" supertab config
let g:SuperTabDefaultCompletionType='<c-x><c-u>'            " 'user' defined default completion type
let g:SuperTabDefaultCompletionType = 'context'             " 'context' defined default completion type
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabLongestHighlight=1
let g:SuperTabLongestEnhanced=1

" vim gitgutter settings
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

" vim autoclose fix
let g:AutoClosePreserveDotReg = 0

" Emmet
let g:user_emmet_expandabbr_key='<C-e>'

" vim settings
syntax enable
filetype plugin indent on
set pumheight=20                                                " Limit popup menu height
set complete-=t                                                 " Do not search tag files when auto-completing
set complete-=i                                                 " Do not search include files when auto-completing
set completeopt=longest,menuone                                 " Complete options (disable preview scratch window, longest removed to aways show menu)
set pumheight=20                                                " Limit popup menu height
set concealcursor=inv                                           " Conceal in insert (i), normal (n) and visual (v) modes
set conceallevel=0                                              " Hide concealed text completely unless replacement character is defined
set mouse=a                                                     " Mouse Support
set clipboard=unnamedplus                                       " Copy to Clipboard
set autoindent                                                  " Does nothing more than copy the indentation from the previous line, when starting a new line.
set smartindent                                                 " Atomatically inserts one extra level of indentation in some cases, and works for C-like files. fcs up stylus :)
set tabstop=2 shiftwidth=2 softtabstop=2 expandtab              " Tabs Settings
set cursorcolumn cursorline                                     " Creates a cross around the cursor
set number                                                      " Shows Line numbers on left
set showcmd                                                     " Show Command line
set lazyredraw                                                  " Fixes render also faster render
set ttyfast                                                     " Fixes ssh render `SOMETIMES`
set wildmenu                                                    " Better Tab Completion For File Names
set showmatch                                                   " Shows maching parethesis and stuff
set incsearch                                                   " Shows the next match while entering a search
set hlsearch                                                    " Keeps the hightlight from search
set backup                                                      " Backup settings starts here
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup                                                 " Backup settings  ends here
set encoding=utf-8                                              " Encoding fix
set fileencoding=utf-8                                          " Encoding fix
set list                                                        " Show whitespaces and stuff
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:. " Sets the icons for list

set background=dark
colorscheme nord

" vim  commands to execute each time you go to normal mode
au CursorHold,CursorHoldI,InsertLeave * SyntasticCheck          "checks for errors
au BufWritePre * :%s/\s\+$//e                                   "Trim spaces
au user Node if &filetype == "javascript" | setlocal expandtab | endif

