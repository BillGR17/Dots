if empty(glob('~/.config/nvim/autoload/plug.vim'))
  sil !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  au VimEnter * PlugInstall --sync | so $MYVIMRC
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
  Plug 'airblade/vim-gitgutter'
  Plug 'scrooloose/nerdtree'
  Plug 'arcticicestudio/nord-vim'
  Plug 'chrisbra/Colorizer'
call plug#end()

" All configs that are not associated with plugin are on conf folder
" Enable syntax & lang format & lang preferences
so ~/.config/nvim/conf/format.vim
" Set custom status line
so ~/.config/nvim/conf/statusline.vim
" Load or create session
so ~/.config/nvim/conf/session.vim
" Set important settings here
so ~/.config/nvim/conf/pref.vim
" nvim terminal-emulator settings
so ~/.config/nvim/conf/term.vim
" Better Controls to create new windows
so ~/.config/nvim/conf/window.vim
" Better Controls to edit code
so ~/.config/nvim/conf/editor-keys.vim

" Plugin Extras configs go to the plug_conf folder
so ~/.config/nvim/plug_conf/nerdtree.vim
so ~/.config/nvim/plug_conf/ale.vim
so ~/.config/nvim/plug_conf/emmet.vim
so ~/.config/nvim/plug_conf/gitgutter.vim
so ~/.config/nvim/plug_conf/deoplete.vim
so ~/.config/nvim/plug_conf/colorizer.vim
