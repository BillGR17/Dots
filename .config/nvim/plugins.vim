let s:dein_path = '$HOME/.cache/dein'
let s:dein_src = s:dein_path . '/repos/github.com/Shougo/dein.vim'
if !exists(s:dein_src)
  if &runtimepath !~# '/dein.vim'
    exe '!git clone https://github.com/Shougo/dein.vim' s:dein_src
  en
en
exe 'se rtp+=' . s:dein_src
cal dein#begin(s:dein_path)
cal dein#add(s:dein_src)
" Better Lang Syntax
cal dein#add('sheerun/vim-polyglot')
" Tools
cal dein#add('dense-analysis/ale',{
      \'hook_add':"
      \ let g:ale_linters = {
      \   'c': ['clang'],
      \   'javascript': ['eslint']
      \ }\n
      \ let g:ale_pattern_options = {
      \   '.*\.hbs$': {'ale_enabled': 0},
      \   '.*\.handlebars$': {'ale_enabled': 0}
      \ }\n
      \"})
      " added some stuff bellow
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
cal dein#add('arcticicestudio/nord-vim',{
      \ 'hook_add':'colo nord'
      \})
cal dein#add('rrethy/vim-hexokinase',
      \ {'build': 'make hexokinase'}) " There is also a config down below
cal dein#end()
if dein#check_install()
 cal dein#install()
endif
let g:ale_open_list=0
" Fix multiple cursor bug with deoplete
fu! Multiple_cursors_before()
  if deoplete#is_enabled()
    cal deoplete#disable()
    let g:deoplete_is_enable_before_multi_cursors = 1
  el
    let g:deoplete_is_enable_before_multi_cursors = 0
  en
endf
fu! Multiple_cursors_after()
  if g:deoplete_is_enable_before_multi_cursors
    cal deoplete#enable()
  en
endf
let g:Hexokinase_optInPatterns = [ 'full_hex', 'triple_hex', 'rgb', 'rgba', 'hsl', 'hsla', 'colour_names']
