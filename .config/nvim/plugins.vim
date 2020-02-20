let s:deinPath='$HOME/.config/nvim/dein'
let s:f_init=empty(glob(s:deinPath))
if s:f_init
  sil !curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh |bash /dev/stdin ~/.config/nvim/dein
en
se rtp+=$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim
if dein#load_state(s:deinPath)
  cal dein#begin(s:deinPath)
  cal dein#add('$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim')
  cal dein#add('sheerun/vim-polyglot')
  " Better Lang Syntax
  cal dein#add('sheerun/vim-polyglot')
  " Tools
  cal dein#add('dense-analysis/ale',{
        \'hook_add':"
        \ let g:ale_open_list=1\n
        \ let g:ale_linters = {
        \   'c': ['clang'],
        \   'javascript': ['eslint']
        \ }\n
        \ let g:ale_pattern_options = {
        \   '.*\.hbs$': {'ale_enabled': 0},
        \   '.*\.handlebars$': {'ale_enabled': 0}
        \ }\n
        \ aug CloseLoclistWindowGroup\n
        \   au!\n
        \   au QuitPre * if empty(&buftype) | lcl | en\n
        \ aug END\n
        \"})
  cal dein#add('Shougo/deoplete.nvim',
        \{'hook_add': 'let g:deoplete#enable_at_startup=1'})
  cal dein#add('tbodt/deoplete-tabnine',
        \{ 'build': './install.sh' })
  cal dein#add('mattn/emmet-vim',{
        \ 'hook_add': "
        \ let g:user_emmet_expandabbr_key='<C-e>'\n
        \ let g:user_emmet_install_global=0\n
        \ au FileType html,html.*,php EmmetInstall\n
        \"})
  cal dein#add('terryma/vim-multiple-cursors')
  " UI & Tools
  cal dein#add('airblade/vim-gitgutter',{
        \ 'hook_add':"
        \ let g:gitgutter_realtime=1\n
        \ let g:gitgutter_eager=0\n
        \"})
  cal dein#add('preservim/nerdtree',
        \ {'hook_add':"
        \ fu Nerd_tog()\n
        \   NERDTreeToggle\n
        \   wincmd p\n
        \   if filereadable(expand(@%)) != 0 && g:NERDTree.IsOpen()\n
        \     NERDTreeFind\n
        \     wincmd p\n
        \   en\n
        \ endf\n
        \ au VimEnter * call Nerd_tog()\n
        \ let g:NERDTreeStatusline = '%#NonText#'\n
        \ let g:NERDTreeIgnore=[]\n
        \ let g:NERDTreeShowHidden=1\n
        \ let g:NERDTreeMapOpenInTab='<ENTER>'\n
        \ au VimLeavePre * NERDTreeClose\n
        \ nm <silent> <C-\\> :cal Nerd_tog()<CR>\n
        \ im <silent> <C-\\> <ESC> :cal Nerd_tog()<CR>\n
        \"})
  cal dein#add('arcticicestudio/nord-vim',{
        \ 'hook_add':'colo nord'
        \})
  cal dein#add('chrisbra/Colorizer', {
        \'hook_add': "
        \ au WinEnter * :ColorHighlight\n
        \ nm <silent> <F11> :ColorHighlight<CR>\n
        \ im <silent> <F11> <ESC> :ColorHighlight<CR>\n
        \"})
  cal dein#end()
  cal dein#save_state()
  if s:f_init
    cal dein#install() --sync|so $MYVIMRC
  en
en
cal dein#call_hook('source')
cal dein#remote_plugins()
