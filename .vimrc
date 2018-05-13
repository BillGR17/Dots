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
call plug#end()
" vim nerdtree on start
au vimenter * NERDTree
au VimEnter * wincmd p "dont focus on nerdtree on open
let NERDTreeShowHidden=1 "show hidden files

" Recommended settings from syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*


let g:syntastic_javascript_checkers = ['eslint'] " install esling with sudo npm i -g eslint or from linux pacages
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" vim javascript settings

" clang config
let g:clang_use_library = 1                                 " Use libclang directly
let g:clang_library_path ='/usr/lib64/libclang.so'           " Path to the libclang on the system
let g:clang_complete_auto = 1                               " Run autocompletion immediatelly after ->, ., ::
let g:clang_complete_copen = 1                              " Open quickfix window on error
let g:clang_periodic_quickfix = 0                           " Turn-off periodic updating of quickfix window (g:ClangUpdateQuickFix() does the same)
let g:clang_snippets = 1                                   " Enable function args autocompletion, template parameters, ...
let g:clang_snippets_engine = 'ultisnips'                   " Use UltiSnips engine for function args autocompletion (provides mechanism to jump over to the next argument)
let g:clang_conceal_snippets = 1                            " clang_complete engine related setting

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" supertag config
let g:SuperTabDefaultCompletionType='<c-x><c-u>'            " 'user' defined default completion type
let g:SuperTabDefaultCompletionType = 'context'             " 'context' defined default completion type
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabLongestHighlight=1
let g:SuperTabLongestEnhanced=1

" vim gitgutter settings
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

"vim autoclose fix
let g:AutoClosePreserveDotReg = 0


" vim settings
set pumheight=20 " Limit popup menu height
set mouse=a
set autoindent
set smartindent
set smarttab
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set showcmd
set number
set lazyredraw
set ttyfast
set wildmenu
set showmatch
set incsearch
set hlsearch
set clipboard=unnamedplus
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup
set encoding=utf-8
set fileencoding=utf-8
set listchars+=space:.
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:.
set list

" vim key settings
let g:user_emmet_expandabbr_key='<C-e>'
" vim  commands to execute each time you go to normal mode
au CursorHold,CursorHoldI,InsertLeave * SyntasticCheck "checks for errors
au BufWritePre * :%s/\s\+$//e "removes whitespaces
au user Node if &filetype == "javascript" | setlocal expandtab | endif

